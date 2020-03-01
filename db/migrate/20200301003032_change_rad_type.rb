class ChangeRadType < ActiveRecord::Migration[6.0]
  def change
    change_column :locations, :radius, :decimal
  end
end
