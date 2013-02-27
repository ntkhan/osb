class RenameReminderToNotification < ActiveRecord::Migration
  def up
    rename_table :reminders, :notifications
  end

  def down
    rename_table :notifications, :reminders
  end
end
