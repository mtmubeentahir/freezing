class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.float :temprature
      t.float :humidity
      t.float :battery_charge
      t.integer :sequence
      t.references :thermostat, foreign_key: true

      t.timestamps
    end
  end
end
