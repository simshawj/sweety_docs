class AddDateAndValuesToDailyLog < ActiveRecord::Migration[5.0]
  def change
    add_column :daily_logs, :log_date, :date
    add_column :daily_logs, :values, :string
  end
end
