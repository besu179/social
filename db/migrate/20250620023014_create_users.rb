class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false
      add_index :users, :email, unique: true

      t.timestamps
    end
  end
end
