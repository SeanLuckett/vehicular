class CreateVehicleOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicle_options do |t|
      t.integer :vehicle_id
      t.integer :option_id

      t.timestamps
    end

    add_index :vehicle_options, [:vehicle_id, :option_id], unique: true
  end
end
