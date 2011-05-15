class CreateElements < ActiveRecord::Migration
  def self.up
    create_table :elements do |t|
      t.belongs_to :dynamic_page
      t.integer :position
      t.references :elem, :polymorphic => true
      t.integer :page_area
      t.string :title
      t.boolean :display_title, :default => true
      t.string :html_id
      t.timestamps
    end

    add_index :elements, :dynamic_page_id
    add_index :elements, [:dynamic_page_id, :page_area, :position]
    add_index :elements, [:elem_id, :elem_type]
  end

  def self.down
    remove_index :elements, :dynamic_page_id
    remove_index :elements, [:dynamic_page_id, :page_area, :position]
    remove_index :elements, [:elem_id, :elem_type]
    drop_table :elements
  end
end
