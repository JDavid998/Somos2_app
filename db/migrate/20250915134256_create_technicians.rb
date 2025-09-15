class CreateTechnicians < ActiveRecord::Migration[8.0]
  def change
    create_table :technicians do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.boolean :active, default: true

      t.timestamps
    end
    
    add_index :technicians, :email, unique: true
  end
end