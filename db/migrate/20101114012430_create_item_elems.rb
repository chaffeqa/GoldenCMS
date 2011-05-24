class CreateItemElems < ActiveRecord::Migration
  def change
    create_table :item_elems do |t|
      t.string :display_type
      t.belongs_to :item
      t.timestamps
    end

    add_index :item_elems, :item_id
  end
end
