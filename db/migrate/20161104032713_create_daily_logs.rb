class CreateDailyLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_logs do |t|

      t.timestamps
    end
  end
end
