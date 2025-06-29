class CreateRelationships < ActiveRecord::Migration[8.0]
  def change
    create_table :relationships do |t|
      t.integer :follower_id, null: false
      t.integer :followed_id, null: false
      t.timestamps
    end

    add_index :relationships, [:follower_id, :followed_id], unique: true
    add_index :relationships, :followed_id
  end
end
