class CreateItemElems < ActiveRecord::Migration
  def change
    create_table :item_elems do |t|
      t.string :display_type
      t.belongs_to :item
      t.belongs_to :element
      t.timestamps
    end

    add_index :item_elems, :element_id
    add_index :item_elems, :item_id
  end
end
