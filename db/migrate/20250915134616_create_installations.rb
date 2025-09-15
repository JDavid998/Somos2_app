class CreateInstallations < ActiveRecord::Migration[8.0]
  def change
    create_table :installations do |t|
      t.string :customer_name, null: false
      t.text :customer_address, null: false
      t.string :customer_phone
      t.date :scheduled_date, null: false
      t.time :start_time, null: false
      t.integer :duration_hours, null: false
      t.string :status, default: 'pending'
      t.references :technician, null: true, foreign_key: true
      t.text :notes

      t.timestamps
    end
    
    add_index :installations, [:scheduled_date, :start_time]
    add_index :installations, :status
  end
end