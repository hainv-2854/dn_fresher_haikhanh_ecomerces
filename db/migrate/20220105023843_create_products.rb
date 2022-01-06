class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.references :category, null: false, foreign_key: true
      t.string :image
      t.decimal :price
      t.integer :quantity
      t.text :description

      t.timestamps
    end
  end
end
