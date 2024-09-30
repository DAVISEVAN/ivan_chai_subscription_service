class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.string :title, null: false
      t.decimal :price, precision: 8, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.string :frequency, null: false
      t.references :customer, foreign_key: true, null: false
      t.references :tea, foreign_key: true, null: false

      t.timestamps
    end
  end
end