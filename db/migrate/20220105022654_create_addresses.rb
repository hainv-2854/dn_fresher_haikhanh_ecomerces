class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.text :address_detail
      t.references :user, null: false, foreign_key: true
      t.boolean :is_default, default: false
      t.string :phone

      t.timestamps
    end
  end
end
