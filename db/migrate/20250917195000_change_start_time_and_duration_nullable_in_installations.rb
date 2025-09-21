class ChangeStartTimeAndDurationNullableInInstallations < ActiveRecord::Migration[8.0]
  def change
    change_column_null :installations, :start_time, true
    change_column_null :installations, :duration_hours, true
  end
end
