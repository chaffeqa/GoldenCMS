class CreateItemCategories < ActiveRecord::Migration
  def change
    create_table :item_pages do |t|
      t.belongs_to :item
      t.belongs_to :node
      t.timestamps
    end

    add_index :item_pages, :item_id
    add_index :item_pages, :node_id
    add_index :item_pages, [:item_id, :node_id]
  end
end
