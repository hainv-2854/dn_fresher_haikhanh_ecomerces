class AddRejectedReasonToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :rejected_reason, :string
  end
end
