class FixActivatedAtPrecision < ActiveRecord::Migration[8.0]
  def up
    # First set activated_at for existing users
    User.where(activated_at: nil).update_all(activated_at: Time.zone.now)
    
    # Then change the column to be NOT NULL
    change_column :users, :activated_at, :datetime, null: false, precision: 6
    change_column :users, :reset_sent_at, :datetime, null: true, precision: 6
  end

  def down
    change_column :users, :activated_at, :datetime, precision: nil
    change_column :users, :reset_sent_at, :datetime, precision: nil
  end
end
