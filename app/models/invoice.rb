class Invoice < ActiveRecord::Base
  acts_as_archival
  acts_as_paranoid
  belongs_to :client
  belongs_to :invoice
  belongs_to :payment_term
  has_many :invoice_line_items, :dependent => :destroy
  has_many :payments
  has_many :sent_emails, :as => :notification
  attr_accessible :client_id, :discount_amount, :discount_percentage, :invoice_date, :invoice_number, :notes, :po_number, :status, :sub_total, :tax_amount, :terms, :invoice_total, :invoice_line_items_attributes, :archive_number, :archived_at, :deleted_at, :payment_terms_id, :due_date
  accepts_nested_attributes_for :invoice_line_items, :reject_if => proc { |line_item| line_item['item_id'].blank? }, :allow_destroy => true
  paginates_per 10
  default_scope order("#{self.table_name}.created_at DESC")
  before_destroy :change_status
  before_create :set_invoice_number

  def set_invoice_number
    self.invoice_number = Invoice.get_next_invoice_number(nil)
  end

  def change_status
    self.update_attribute("status", "sent")
  end

  def tooltip
    case self.status
      when "draft"
        "Invoice created, but you have not notified your client. Your client will not see this invoice if they log in."
      when "sent"
        "Your client has been notified. When they log in the invoice will be visible for printing and payment."
      when "paid"
        "Your client has paid this invoice - either online or you have received their funds and updated your records."
      when "partial"
        "Your client has partially paid this invoice. Hover over the total to see the amount outstanding."
      when "draft-partial"
        "Invoice created and partial payment applied. Your client has no access to this invoice."
      when "disputed"
        "Your client has disputed this invoice. Click on this invoice to view their comments."
      when "viewed"
        "Your client has viewed this invoice, but not made any payments."
      else
        ""
    end
  end

  def currency_symbol
    # self.company.currency_symbol
    "$"
  end

  def currency_code
    # self.company.currency_code
    "USD"
  end

  class << self
    def get_next_invoice_number user_id
      ((Invoice.maximum("id") || 0) + 1).to_s.rjust(5, "0")
    end
  end

  def description
    self.invoice_line_items.first.item_description unless self.invoice_line_items.blank?
  end

  def self.paid_invoices ids
    where("id IN(?) AND status = 'paid'", ids)
  end

  def total
    self.invoice_line_items.sum { |li| (li.item_unit_cost || 0) *(li.item_quantity || 0) }
  end

  def duplicate_invoice
    new_invoice = self.dup
    new_invoice.invoice_line_items << self.invoice_line_items.map { |line_item| line_item.dup }
    new_invoice.save
    new_invoice
  end

  def use_as_template
    invoice = self.dup
    invoice.invoice_number = Invoice.get_next_invoice_number(nil)
    invoice.invoice_date = Date.today
    invoice.invoice_line_items << self.invoice_line_items.map { |line_item| line_item.dup }
    invoice
  end

  def self.multiple_invoices ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids)
  end

  def self.archive_multiple ids
    self.multiple_invoices(ids).each { |invoice| invoice.archive }
  end

  def self.delete_multiple ids
    invoices_with_payments = []
    self.multiple_invoices(ids).each { |invoice|
      if invoice.payments.where("payment_type !='credit' or payment_type is null").blank?
        invoice.destroy
      else
        invoices_with_payments << invoice
      end
    }
    invoices_with_payments #if there are invoices with payments
  end

  def self.delete_invoices_with_payments ids, convert_to_credit
    self.multiple_invoices(ids).each { |invoice|
      if convert_to_credit
        invoice_total_payments = invoice.payments.where("payment_type !='credit' or payment_type is null").sum('payment_amount')
        self.add_credit_payment invoice, invoice_total_payments
      end
      invoice.payments.with_deleted.where("payment_type='credit' or payment_type is null").each { |payment| payment.destroy! }
      invoice.destroy
    }
  end

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
    case params[:status]
      when "active" then
        self.unarchived.page(params[:page])
      when "archived" then
        self.archived.page(params[:page])
      when "deleted" then
        self.only_deleted.page(params[:page])
    end
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

  def notify current_user, id
    encrypted_id = Base64.encode64(id)
    InvoiceMailer.delay.new_invoice_email(self.client, self, encrypted_id, current_user)
  end

  def send_invoice current_user, id
    status = if self.status == "draft-partial"
               "partial"
             elsif self.status == "draft"
               "sent"
             else
               self.status
             end
    self.notify(current_user, id) if self.update_attributes(:status => status)
  end

  def self.total_invoices_amount
    sum('invoice_total')
  end

  def self.add_credit_payment invoice, amount
    credit_pay = Payment.new
    credit_pay.payment_type = 'credit'
    credit_pay.invoice_id = invoice.id
    credit_pay.payment_date = Date.today
    credit_pay.notes = "Converted from payments for invoice# #{invoice.invoice_number}"
    credit_pay.payment_amount = amount
    credit_pay.save
  end

  def partial_payments
    where("status = 'partial'")
  end

  def encrypted_id
    Base64.encode64(encrypt(self.id))
  end
end