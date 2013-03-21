class Invoice < ActiveRecord::Base
  include ::OSB

  default_scope order("#{self.table_name}.created_at DESC")
  scope :multiple, lambda { |ids_list| where("id in (?)", ids_list.is_a?(String) ? ids_list.split(',') : [*ids_list]) }

  # constants
  STATUS_DESCRIPTION = {
      draft: 'Invoice created, but you have not notified your client.',
      sent: 'Invoice created and sent to your client.',
      viewed: 'Client has clicked the invoice URL in the email and viewed the invoice in browser.',
      paid: 'Client has made full payment against the invoice.',
      partial: 'Client has made partial payment against the invoice.',
      draft_partial: 'Payment received against the draft invoice.',
      disputed: 'Client has disputed this invoice.',
  }

  attr_accessible :client_id, :discount_amount, :discount_percentage, :invoice_date, :invoice_number, :notes, :po_number, :status, :sub_total, :tax_amount, :terms, :invoice_total, :invoice_line_items_attributes, :archive_number, :archived_at, :deleted_at, :payment_terms_id, :due_date, :last_invoice_status

  # associations
  belongs_to :client
  belongs_to :invoice
  belongs_to :payment_term
  has_many :invoice_line_items, :dependent => :destroy
  has_many :payments
  has_many :sent_emails, :as => :notification
  has_many :credit_payments, :dependent => :destroy

  accepts_nested_attributes_for :invoice_line_items, :reject_if => proc { |line_item| line_item['item_id'].blank? }, :allow_destroy => true

  # callbacks
  before_destroy :sent!
  before_create :set_invoice_number
  after_destroy :destroy_credit_payments

  paginates_per 10

  acts_as_archival
  acts_as_paranoid

  #include ActionView::Helpers::NumberHelper

  def set_invoice_number
    self.invoice_number = Invoice.get_next_invoice_number(nil)
  end

  def sent!
    update_attributes(:last_invoice_status => status, :status => 'sent')
  end

  def viewed!
    update_attributes(:last_invoice_status => status, :status => 'viewed') if status == 'sent'
  end

  def draft!
    update_attributes(:last_invoice_status => status, :status => 'draft')
  end

  def draft_partial!
    update_attributes(:last_invoice_status => status, :status => 'draft-partial')
  end

  def partial!
    update_attributes(:last_invoice_status => status, :status => 'partial')
  end

  def has_payments?
    payments.present?
  end

  def unpaid?
    self.status != 'paid'
  end

  def paid?
    !unpaid?
  end


  def unpaid_amount
    #TODO: deduct the partial payment from invoice total if any
    self.invoice_total
  end

  # This doesn't actually dispute the invoice. It just updates the invoice status to dispute.
  # To perform a full 'dispute' process use *Services::InvoiceService.dispute_invoice(invoice_id, dispute_reason)*
  def disputed!
    self.update_attributes(:last_invoice_status => status, :status => 'disputed')
  end

  def dispute_history
    self.sent_emails.where("type = 'Disputed'")
  end

  def delete_credit_payments
    self.payments.with_deleted.where("payment_method = 'Credit'").map(&:destroy!)
  end

  def delete_none_credit_payments
    self.payments.with_deleted.where("payment_type !='credit' or payment_type is null").map(&:destroy!)
  end

  def non_credit_payment_total
    self.payments.where("payment_type !='credit' or payment_type is null").sum('payment_amount')
  end

  def tooltip
    STATUS_DESCRIPTION[self.status.gsub('-', '_').to_sym]
  end

  def has_payment?
    payments.where("payment_type !='credit' or payment_type is null").present?
  end

  def currency_symbol
    # self.company.currency_symbol
    "$"
  end

  def currency_code
    # self.company.currency_code
    "USD"
  end

  def self.get_next_invoice_number user_id
    ((Invoice.with_deleted.maximum("id") || 0) + 1).to_s.rjust(5, "0")
  end

  #def self.paid_invoices ids
  #  where("id IN(?) AND status = 'paid'", ids)
  #end

  def total
    self.invoice_line_items.sum { |li| (li.item_unit_cost || 0) *(li.item_quantity || 0) }
  end

  def duplicate_invoice
    (self.dup.invoice_line_items << self.invoice_line_items.map(&:dup)).save
  end

  def use_as_template
    invoice = self.dup
    invoice.invoice_number = Invoice.get_next_invoice_number(nil)
    invoice.invoice_date = Date.today
    invoice.invoice_line_items << self.invoice_line_items.map(&:dup)
    invoice
  end

  def self.multiple_invoices ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids)
  end

  #def self.archive_multiple ids
  #  self.multiple_invoices(ids).each { |invoice| invoice.archive }
  #end

  #def self.delete_multiple ids
  #  invoices_with_payments = []
  #  self.multiple_invoices(ids).each do |invoice|
  #    if invoice.payments.where("payment_type !='credit' or payment_type is null").blank?
  #      invoice.destroy
  #    else
  #      invoices_with_payments << invoice
  #    end
  #  end
  #  invoices_with_payments #if there are invoices with payments
  #end

  #def self.delete_invoices_with_payments ids, convert_to_credit
  #  self.multiple_invoices(ids).each { |invoice|
  #    if convert_to_credit
  #      invoice.payments.with_deleted.where("payment_method = 'Credit'").each { |payment| payment.destroy! }
  #      invoice_total_payments = invoice.payments.where("payment_type !='credit' or payment_type is null").sum('payment_amount')
  #      self.add_credit_payment invoice, invoice_total_payments
  #    end
  #    invoice.delete_non_credit_payments
  #    invoice.destroy
  #  }
  #end

  def self.recover_archived ids
    self.multiple_invoices(ids).each { |invoice| invoice.unarchive }
  end

  def self.recover_deleted ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids).only_deleted.each do |invoice|
      invoice.recover
      invoice.unarchive
    end
  end

  def self.filter params
    mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
    method = mappings[params[:status].to_sym]
    self.send(method).page(params[:page]).per(params[:per])
  end

  def self.paid_full ids
    self.multiple_invoices(ids).each do |invoice|
      Payment.create({
                         :payment_amount => Payment.update_invoice_status(invoice.id, invoice.invoice_total.to_i),
                         :invoice_id => invoice.id,
                         :paid_full => 1,
                         :payment_date => Date.today
                     })
    end
  end

  def notify current_user, id = nil
    InvoiceMailer.delay.new_invoice_email(self.client, self, self.encrypted_id, current_user)
  end

  def send_invoice current_user, id
    status = if self.status == "draft-partial"
               "partial"
             elsif self.status == "draft" || self.status == "viewed" || self.status =="disputed"
               "sent"
             else
               self.status
             end
    self.notify(current_user, id) if self.update_attributes(:status => status)
  end

  def total_invoices_amount
    sum('invoice_total')
  end

  def create_credit(amount)
    credit_pay = Payment.new
    credit_pay.payment_type = 'credit'
    credit_pay.invoice_id = self.id
    credit_pay.payment_date = Date.today
    credit_pay.notes = "Converted from payments for invoice# #{self.invoice_number}"
    credit_pay.payment_amount = amount
    credit_pay.credit_applied = 0.00
    credit_pay.save
  end

  def partial_payments
    where("status = 'partial'")
  end

  #def credit_payments
  #  payments.where("payment_type = 'credit'")
  #end

  def encrypted_id
    OSB::Util::encrypt(self.id)
  end

  def paypal_url(return_url, notify_url)
    values = {
        #:business => 'onlyfo_1362112292_per@hotmail.com',
        :business => 'onlyforarif-facilitator@gmail.com',
        :cmd => '_cart',
        :upload => 1,
        :return => return_url,
        :notify_url => notify_url,
        :invoice => id,
        :item_name => "Test",
        :amount => invoice_total
    }
    #item_discount = number_with_precision(-(discount_amount.to_d / (invoice_line_items.size.to_d)),:precision => 2).to_d
    #invoice_line_items.each_with_index do |item, index|
    #  values.merge!({
    #                    "amount_#{index+1}" => item.item_unit_cost,
    #                    "item_name_#{index+1}" => (item.item.item_name rescue ""),
    #                    "item_number_#{index+1}" => item.id,
    #                    "quantity_#{index+1}" => item.item_quantity,
    #                    "tax_#{index+1}" => ((item.tax1.percentage rescue 0) + (item.tax2.percentage rescue 0))
    #                    #"discount_amount_#{index+1}" => (index+1 == invoice_line_items.size ? last_invoice_discount(item_discount, discount_amount, invoice_line_items.size) : item_discount)
    #                })
    #end
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end

  def update_dispute_invoice(current_user, id, response_to_client)
    self.update_attribute('status', 'sent')
    self.notify(current_user, id)
    self.sent_emails.create({
                                :content => response_to_client,
                                :sender => current_user.email, #User email
                                :recipient => self.client.email, #client email
                                :subject => 'Response to client',
                                :type => 'Disputed',
                                :date => Date.today
                            })
  end

  def tax_details
    taxes = []
    tlist = Hash.new(0)
    self.invoice_line_items.each do |li|
      next unless [li.item_unit_cost, li.item_quantity].all?
      line_total = li.item_unit_cost * li.item_quantity
      # calculate tax1 and tax2
      taxes.push({name: li.tax1.name, pct: "#{li.tax1.percentage.to_s.gsub('.0', '')}%", amount: (line_total * li.tax1.percentage / 100.0)}) unless li.tax1.blank?
      taxes.push({name: li.tax2.name, pct: "#{li.tax2.percentage.to_s.gsub('.0', '')}%", amount: (line_total * li.tax2.percentage / 100.0)}) unless li.tax2.blank?
    end

    taxes.each do |tax|
      tlist["#{tax[:name]} #{tax[:pct]}"] += tax[:amount]
    end
    tlist
  end

  def status_after_payment_deleted
    Rails.logger.debug "\e[1;31m Before: #{status} \e[0m"

    # update invoice status when a payment is deleted
    case status
      when "draft-partial" then draft! unless has_payments?

      when "partial" then
        if has_payments?
           partial!
        else
          last_invoice_status == "disputed" ? disputed! : sent!
        end

      when "paid" then
        if has_payments?
           last_invoice_status == "draft-partial" ? draft_partial! : partial!
        else
          last_invoice_status == "disputed" ? disputed! : sent!
        end

      when "disputed" then (has_payments? ? partial! : disputed! )
      else
    end if present?

    Rails.logger.debug "\e[1;31m After: #{status} \e[0m"
  end

  def destroy_credit_payments
    credit_payments.map(&:destroy)
  end

end