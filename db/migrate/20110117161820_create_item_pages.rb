class CreateItemPages < ActiveRecord::Migration
  def change
    create_table :item_pages do |t|
      t.belongs_to :item
      t.belongs_to :page
      t.timestamps
    end

    add_index :item_pages, :item_id
    add_index :item_pages, :page_id
  end
end
