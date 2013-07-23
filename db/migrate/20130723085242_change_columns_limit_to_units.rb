class ChangeColumnsLimitToUnits < ActiveRecord::Migration
  def up
    change_column :units, :age,    :integer, default: 0, null: false, limit: 100
    change_column :units, :salary, :integer, default: 0, null: false, limit: 1000000
    change_column :units, :growth, :integer, default: 0, null: false, limit: 200
    change_column :units, :weight, :integer, default: 0, null: false, limit: 200
  end

  def down
    change_column :units, :age,    :integer
    change_column :units, :salary, :integer
    change_column :units, :growth, :integer
    change_column :units, :weight, :integer
  end
end
