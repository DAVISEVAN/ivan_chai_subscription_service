class CreateTeas < ActiveRecord::Migration[7.1]
  def change
    create_table :teas do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :temperature, null: false
      t.integer :brew_time, null: false

      t.timestamps
    end
  end
end