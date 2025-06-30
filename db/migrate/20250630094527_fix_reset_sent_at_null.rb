class FixResetSentAtNull < ActiveRecord::Migration[8.0]
  def up
    # First update existing records to have a timestamp
    User.where(reset_sent_at: nil).update_all(reset_sent_at: Time.zone.now)
    
    # Then make the column NOT NULL
    change_column :users, :reset_sent_at, :datetime, null: false, precision: 6
  end

  def down
    change_column :users, :reset_sent_at, :datetime, null: true
  end
end
