class AddIndexToRelationships < ActiveRecord::Migration[8.0]
  def change
    add_index :relationships, :follower_id
  end
end
