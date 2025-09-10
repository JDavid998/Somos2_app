class CreateTecnicos < ActiveRecord::Migration[8.0]
  def change
    create_table :tecnicos do |t|
  t.string :name
  t.string :email

      t.timestamps
    end
  end
end
