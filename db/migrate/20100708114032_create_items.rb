class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      # Basic Item Attributes
      t.string :name
      t.decimal :cost, :precision => 8, :scale => 2, :default => 0
      t.string :part_number
      t.string :short_description
      t.text :long_description
      t.belongs_to :node

      t.timestamps
    end

    add_index :items, :node_id
    add_index :items, :part_number
  end
end

