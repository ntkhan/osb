class Invoice < ActiveRecord::Base
  acts_as_archival
  acts_as_paranoid
  belongs_to :client
  belongs_to :invoice
  has_many :invoice_line_items, :dependent => :destroy
  has_many :payments
  attr_accessible :client_id, :discount_amount, :discount_percentage, :invoice_date, :invoice_number, :notes, :po_number, :status, :sub_total, :tax_amount, :terms, :invoice_total, :invoice_line_items_attributes
  accepts_nested_attributes_for :invoice_line_items, :reject_if => proc { |line_item| line_item['item_id'].blank? }, :allow_destroy => true
  paginates_per 10

  class << self
    def get_next_invoice_number user_id
      ((Invoice.maximum("id") || 0) + 1).to_s.rjust(5, "0")
    end
  end

  def description
    "Invoice Description"
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

  def self.multiple_invoices ids
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
    where("id IN(?)", ids).only_deleted.each {|invoice| invoice.recover}
  end

  def self.filter params
    case params[:status]
      when "active"   then self.unarchived.page(params[:page])
      when "archived" then self.archived.page(params[:page])
      when "deleted"  then self.only_deleted.page(params[:page])
    end
  end

end
