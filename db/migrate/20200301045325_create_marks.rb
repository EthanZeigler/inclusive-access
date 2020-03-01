class CreateMarks < ActiveRecord::Migration[6.0]
  def change
    create_table :marks do |t|
      t.string :name
      t.references :mark_type, null: false, foreign_key: true
      t.text :description
      t.decimal :lat
      t.decimal :long
      t.references :user, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
