class Tax < ActiveRecord::Base
  attr_accessible :name, :percentage
  has_many :invoice_line_items
  has_many :items
  validates :name, :presence => true
  validates :percentage, :presence => true
  paginates_per 10
  acts_as_archival
  acts_as_paranoid  :recover_dependent_associations => false
  default_scope order("#{self.table_name}.created_at DESC")

  def self.multiple_taxes ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids)
  end

  def self.archive_multiple ids
    self.multiple_taxes(ids).each {|tax| tax.archive}
  end

  def self.delete_multiple ids
    self.multiple_taxes(ids).each {|tax| tax.destroy}
  end

  def self.recover_archived ids
    self.multiple_taxes(ids).each do |tax|
      tax.archive_number = nil
      tax.archived_at = nil
      tax.save
    end
  end

  def self.recover_deleted ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids).only_deleted.each do |tax|
      tax.recover
      tax.unarchive
    end
  end

  def self.filter params
    case params[:status]
      when "active"   then self.unarchived.page(params[:page])
      when "archived" then self.archived.page(params[:page])
      when "deleted"  then self.only_deleted.page(params[:page])
    end
  end

end
