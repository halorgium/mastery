class CreateMasteryVats < ActiveRecord::Migration
  def change
    create_table :mastery_vats do |t|
      t.string :name
      t.integer :lock_version, :default => 0

      t.timestamps
    end

    add_index :mastery_vats, :name
  end
end
