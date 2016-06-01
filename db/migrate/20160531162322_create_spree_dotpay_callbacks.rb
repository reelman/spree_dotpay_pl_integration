class CreateSpreeDotpayCallbacks < ActiveRecord::Migration
  def change
    create_table :spree_dotpay_callbacks do |t|
      t.text :notification_params
      t.string :status
      t.string :operation_id
      t.integer :order_id, index: true

      t.timestamps null: false
    end
  end
end
