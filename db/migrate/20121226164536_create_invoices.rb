class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :invoice_number
      t.datetime :invoice_date
      t.string :po_number
      t.decimal :discount_percentage
      t.integer :client_id
      t.text :tems
      t.text :notes
      t.string :status
      t.decimal :sub_total
      t.decimal :discount_amount
      t.decimal :tax_amount

      t.timestamps
    end
  end
end
