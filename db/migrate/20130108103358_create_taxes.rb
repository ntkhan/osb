class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :name
      t.decimal :percentage
      t.string :archive_number
      t.datetime :archived_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
