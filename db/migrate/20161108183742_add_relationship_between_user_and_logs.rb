class AddRelationshipBetweenUserAndLogs < ActiveRecord::Migration[5.0]
  def change
    change_table :daily_logs do |t|
      t.belongs_to :user, index: true
    end
  end
end
