class Invoice < ActiveRecord::Base
  acts_as_archival
  acts_as_paranoid
  belongs_to :client
  belongs_to :invoice
  has_many :invoice_line_items, :dependent => :destroy
  has_many :payments
  attr_accessible :client_id, :discount_amount, :discount_percentage, :invoice_date, :invoice_number, :notes, :po_number, :status, :sub_total, :tax_amount, :terms, :invoice_total, :invoice_line_items_attributes, :archive_number, :archived_at, :deleted_at
  accepts_nested_attributes_for :invoice_line_items, :reject_if => proc { |line_item| line_item['item_id'].blank? }, :allow_destroy => true
  paginates_per 10
  default_scope order("#{self.table_name}.created_at DESC")

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
    "Invoice Description"
  end

  def self.paid_invoices ids
    where("id IN(?) AND status = 'paid'",ids)
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
    self.multiple_invoices(ids).each {|invoice| invoice.archive}
  end

  def self.delete_multiple ids
    self.multiple_invoices(ids).each {|invoice| invoice.destroy}
  end

  def self.recover_archived ids
    self.multiple_invoices(ids).each {|invoice| invoice.unarchive}
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
    when "active"   then self.unarchived.page(params[:page])
    when "archived" then self.archived.page(params[:page])
    when "deleted"  then self.only_deleted.page(params[:page])
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

end
