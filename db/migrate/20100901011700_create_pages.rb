class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :menu_name
      t.string :title
      t.string :shortcut
      t.string :displayed
      t.string :layout_name
      t.boolean :cachable
      t.string :ancestry
      t.integer :position
      t.integer :ancestry_depth, :default => 0
      t.string :names_depth_cache # Optional for easier select box implementation
      t.integer :total_element_areas, :default => 0
      t.belongs_to :root_site
      t.belongs_to :site
      t.timestamps
    end
    add_index :pages, :site_id
    add_index :pages, :root_site_id
    add_index :pages, :ancestry
    add_index :pages, :ancestry_depth
    add_index :pages, :shortcut
  end
end

