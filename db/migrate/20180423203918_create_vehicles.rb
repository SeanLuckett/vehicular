class CreateVehicles < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicles do |t|
      t.string :owner
      t.references :model, foreign_key: true

      t.timestamps
    end
  end
end
