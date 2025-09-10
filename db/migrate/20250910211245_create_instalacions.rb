class CreateInstalaciones < ActiveRecord::Migration[8.0]
  def change
    create_table :instalaciones do |t|

  t.string :customer_name
  t.string :adress
  t.string :date
  t.string :start_time
  t.string :duration
  t.references :tecnico, null: false, foreign_key: true

      t.timestamps
    end
  end
end
