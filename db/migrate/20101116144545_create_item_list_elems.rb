class CreateItemListElems < ActiveRecord::Migration
  def change
    create_table :item_list_elems do |t|
      t.references :category
      t.integer :limit
      t.decimal :min_price, :precision => 8, :scale => 2, :default => 0
      t.decimal :max_price, :precision => 8, :scale => 2, :default => 0
      t.string :display_type
      t.belongs_to :element      
      t.timestamps
    end

    add_index :item_list_elems, :element_id
    add_index :item_list_elems, :category_id
  end
end
