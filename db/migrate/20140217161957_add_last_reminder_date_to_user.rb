class AddLastReminderDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_reminder_date, :date
  end
end
