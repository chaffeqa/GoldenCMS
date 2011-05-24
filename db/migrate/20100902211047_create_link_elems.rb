class CreateLinkElems < ActiveRecord::Migration
  def change
    create_table :link_elems do |t|
      t.string :link_name
      t.string :link_type
      t.string :link_url
      t.string :target
      t.string :img_src
      t.boolean :is_image
      t.string :image_style
      t.string :link_file_file_name
      t.string :link_file_content_type
      t.integer :link_file_file_size
      t.datetime :link_file_updated_at
      t.belongs_to :node
      t.belongs_to :image
      t.timestamps
    end

    add_index :link_elems, :element_id
    add_index :link_elems, :node_id
    add_index :link_elems, :image_id
  end
end
