class CreateImageElems < ActiveRecord::Migration
  def change
    create_table :image_elems do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.string :image_style
      t.belongs_to :link_elem
      t.belongs_to :photo_gallery_elem
      t.timestamps
    end
    
    add_index :image_elems, :link_elem_id
    add_index :image_elems, :photo_gallery_elem_id
  end
end

