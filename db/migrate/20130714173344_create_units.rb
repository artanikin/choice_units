class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.integer :age
      t.integer :salary
      t.integer :growth
      t.integer :weight

      t.timestamps
    end
  end
end
