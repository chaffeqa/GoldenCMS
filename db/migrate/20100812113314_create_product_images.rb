class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.belongs_to :item
      t.boolean :primary_image, :default => true
      t.timestamps
    end

    add_index :product_images, :item_id
  end
end
