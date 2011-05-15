class CreateLinkElems < ActiveRecord::Migration
  def self.up
    create_table :link_elems do |t|
      t.string :link_name
      t.string :link_type
      t.string :link_url
      t.belongs_to :node
      t.string :target
      t.belongs_to :image
      t.string :img_src
      t.boolean :is_image
      t.string :image_style
      t.string :link_file_file_name
      t.string :link_file_content_type
      t.integer :link_file_file_size
      t.timestamps
    end

    add_index :link_elems, :node_id
    add_index :link_elems, :image_id
  end

  def self.down
    remove_index :link_elems, :node_id
    remove_index :link_elems, :node
    drop_table :link_elems
  end
end
