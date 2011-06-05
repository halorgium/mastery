class CreateMasteryAuthorities < ActiveRecord::Migration
  def change
    create_table :mastery_authorities do |t|
      t.string :name, :suite_name, :cap_name
      t.text :data
      t.references :vat
      t.integer :lock_version, :default => 0

      t.timestamps
    end
    add_index :mastery_authorities, :vat_id
  end
end
