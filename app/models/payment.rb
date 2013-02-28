class Payment < ActiveRecord::Base
  attr_accessible :invoice_id, :notes, :paid_full, :payment_amount, :payment_date, :payment_method, :send_payment_notification, :archive_number, :archived_at, :deleted_at
  belongs_to :invoice
  has_many :sent_emails, :as => :notification
  paginates_per 10
  acts_as_archival
  acts_as_paranoid
  default_scope order("#{self.table_name}.created_at DESC")
  before_destroy :check_credit_payments

  def check_credit_payments
    false if self.payment_type == "credit" || self.payment_type != nil
  end

  def client_name
    invoice = Invoice.with_deleted.find(self.invoice_id)
    invoice.client.organization_name rescue "no client"
  end

  def client_full_name
    "#{self.invoice.client.first_name rescue ''}  #{self.invoice.client.last_name rescue ''}"
  end

  def self.update_invoice_status inv_id, c_pay, prev_amount= 0
    invoice = Invoice.find(inv_id)
    diff = (self.invoice_paid_amount(invoice.id)- prev_amount + c_pay) - invoice.invoice_total
    if diff > 0
      status = 'paid'
      self.add_credit_payment invoice, diff
      return_v = c_pay - diff
    elsif diff < 0
      status = (invoice.status == 'draft' || invoice.status == 'draft-partial') ? 'draft-partial' : 'partial'
      return_v = c_pay
    else
      status = 'paid'
      return_v = c_pay
    end
    invoice.status = status
    invoice.save
    return return_v
  end

  def self.add_credit_payment invoice, amount
    credit_pay = Payment.new
    credit_pay.payment_type = 'credit'
    credit_pay.invoice_id = invoice.id
    credit_pay.payment_date = Date.today
    credit_pay.notes = "Overpayment against invoice# #{invoice.invoice_number}"
    credit_pay.payment_amount = amount
    credit_pay.save
  end

  def client_credit client_id
    invoice_ids = Invoice.where("client_id = ?", client_id).all
    # total credit
    client_payments = Payment.where("payment_type = 'credit' AND invoice_id in (?)", invoice_ids).all
    client_total_credit = client_payments.sum { |f| f.payment_amount }
    # avail credit
    client_payments = Payment.where("payment_method = 'credit' AND invoice_id in (?)", invoice_ids).all
    client_avail_credit = client_payments.sum { |f| f.payment_amount }
    balance = client_total_credit - client_avail_credit
    return balance
  end

  def self.invoice_remaining_amount inv_id
    invoice = Invoice.find(inv_id)
    invoice_payments = self.invoice_paid_detail(inv_id)
    # invoice_paid_amount =  invoice_payments.sum{|f| f.payment_amount || 0}
    invoice_paid_amount = 0
    invoice_payments.each do |inv_p|
      invoice_paid_amount= invoice_paid_amount + inv_p.payment_amount unless inv_p.payment_amount.blank?
    end
    return invoice.invoice_total - invoice_paid_amount
  end

  def self.invoice_paid_amount inv_id
    invoice_payments = self.invoice_paid_detail(inv_id)
    invoice_paid_amount = 0
    invoice_payments.each do |inv_p|
      invoice_paid_amount= invoice_paid_amount + inv_p.payment_amount unless inv_p.payment_amount.blank?
    end
    return invoice_paid_amount
  end

  def self.invoice_paid_detail inv_id
    Payment.where("invoice_id = ? and (payment_type is null || payment_type != 'credit')", inv_id).all
  end

  def self.multiple_payments ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids)
  end

  def self.archive_multiple ids
    self.multiple_payments(ids).each { |payment| payment.archive }
  end

  def self.delete_multiple ids
    self.multiple_payments(ids).each { |payment| payment.destroy! }
  end

  def self.recover_archived ids
    self.multiple_payments(ids).each { |payment| payment.unarchive }
  end

  def self.recover_deleted ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids).only_deleted.each do |payment|
      payment.recover
      payment.unarchive
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

  def notify_client current_user_email
    PaymentMailer.payment_notification_email(current_user_email, self.invoice.client, self.invoice.invoice_number, self).deliver if self.send_payment_notification
  end

  def self.payments_history client
    ids = client.invoices.collect { |invoice| invoice.id }
    where("invoice_id IN(?)", ids)
  end

  def self.total_payments_amount
    where('payment_type is null or payment_type != "credit"').sum('payment_amount')
  end

  def self.partial_payments invoice_id
    where("invoice_id = ?", invoice_id)
  end
end
