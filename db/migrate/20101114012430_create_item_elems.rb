class CreateItemElems < ActiveRecord::Migration
  def self.up
    create_table :item_elems do |t|
      t.belongs_to :item
      t.string :display_type
      t.timestamps
    end

    add_index :item_elems, :item_id
  end

  def self.down
    remove_index :item_elems, :item_id
    drop_table :item_elems
  end
end
