class AddScheduledTimeToInstallations < ActiveRecord::Migration[8.0]
  def change
    add_column :installations, :scheduled_time, :time
  end
end
