class AddIndexToDailyLogDate < ActiveRecord::Migration[5.0]
  def change
    add_index :daily_logs, :log_date
  end
end
