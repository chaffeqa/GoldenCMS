class CreateItemCategories < ActiveRecord::Migration
  def self.up
    create_table :item_categories do |t|
      t.belongs_to :item
      t.belongs_to :category
      t.timestamps
    end

    add_index :item_categories, :item_id
    add_index :item_categories, :category_id
    add_index :item_categories, [:item_id, :category_id]
  end

  def self.down
    remove_index :item_categories, :item_id
    remove_index :item_categories, :category_id
    remove_index :item_categories, [:item_id, :category_id]
    drop_table :item_categories
  end
end
