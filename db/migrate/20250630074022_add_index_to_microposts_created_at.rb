class AddIndexToMicropostsCreatedAt < ActiveRecord::Migration[8.0]
  def change
    add_index :microposts, :created_at
  end
end
