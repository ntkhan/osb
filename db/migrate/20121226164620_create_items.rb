class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :item_description
      t.decimal :unit_cost
      t.integer :quantity
      t.integer :tax_1
      t.integer :tax_2
      t.boolean :track_invetory
      t.integer :inventory

      t.timestamps
    end
  end
end
