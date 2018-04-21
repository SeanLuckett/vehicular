class CreateModels < ActiveRecord::Migration[5.1]
  def change
    create_table :models do |t|
      t.references :make, foreign_key: true
      t.string :name, null: false
      t.string :year, null: false

      t.timestamps
    end

    add_index :models, [:name, :year], unique: true
  end
end
