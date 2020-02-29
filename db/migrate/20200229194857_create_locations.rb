class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.text :description
      t.decimal :lat
      t.decimal :long
      t.integer :radius
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
