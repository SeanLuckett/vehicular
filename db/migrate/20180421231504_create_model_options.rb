class CreateModelOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :model_options do |t|
      t.integer :model_id
      t.integer :option_id

      t.timestamps
    end

    add_index :model_options, [:model_id, :option_id], unique: true
  end
end
