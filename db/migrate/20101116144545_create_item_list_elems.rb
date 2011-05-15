class CreateItemListElems < ActiveRecord::Migration
  def self.up
    create_table :item_list_elems do |t|
      t.references :category
      t.integer :limit
      t.decimal :min_price, :precision => 8, :scale => 2, :default => 0
      t.decimal :max_price, :precision => 8, :scale => 2, :default => 0
      t.string :display_type
      t.timestamps
    end

    add_index :item_list_elems, :category_id
  end

  def self.down
    remove_index :item_list_elems, :category_id
    drop_table :item_list_elems
  end
end
