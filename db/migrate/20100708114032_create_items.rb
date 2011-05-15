class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      # Basic Item Attributes
      t.string :name
      t.decimal :cost, :precision => 8, :scale => 2, :default => 0
      t.boolean :for_sale
      t.boolean :display
      t.string :part_number
      t.string :short_description
      t.text :long_description
      t.string :weight

      t.timestamps
    end

    add_index :items, :part_number
  end



  def self.down
    remove_index :items, :part_number
    drop_table :items
  end
end

