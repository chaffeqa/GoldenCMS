class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :item_count, :default => 0
      t.belongs_to :parent_category
      t.timestamps
    end

    add_index :categories, :parent_category_id
  end

  def self.down
    remove_index :categories, :parent_category_id
    drop_table :categories
  end
end

