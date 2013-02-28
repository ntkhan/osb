class Item < ActiveRecord::Base
  acts_as_archival
  acts_as_paranoid
  attr_accessible :inventory, :item_description, :item_name, :quantity, :tax_1, :tax_2, :track_inventory, :unit_cost, :archive_number, :archived_at, :deleted_at
  has_many :invoice_line_items, :dependent => :destroy
  belongs_to :tax1, :foreign_key => "tax_1", :class_name => "Tax"
  belongs_to :tax2, :foreign_key => "tax_2", :class_name => "Tax"
  paginates_per 10
  default_scope order("#{self.table_name}.created_at DESC")

  def self.multiple_items ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids)
  end

  def self.is_exits? item_name
    where(:item_name => item_name).present?
  end

  def self.archive_multiple ids
    self.multiple_items(ids).each { |item| item.archive }
  end

  def self.delete_multiple ids
    self.multiple_items(ids).each { |item| item.destroy }
  end

  def self.recover_archived ids
    self.multiple_items(ids).each { |item| item.unarchive }
  end

  def self.recover_deleted ids
    ids = ids.split(",") if ids and ids.class == String
    where("id IN(?)", ids).only_deleted.each do |item|
      item.recover
      item.unarchive
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
end
