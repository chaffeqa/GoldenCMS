class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :title
      t.string :menu_name
      t.string :title
      t.string :shortcut
      t.string :displayed
      t.string :layout_name
      t.string :ancestry
      t.integer :ancestry_depth, :default => 0
      t.string :names_depth_cache # Optional for easier select box implementation
      t.integer :positions, :default => 0
      t.belongs_to :root_site
      t.belongs_to :site
      t.timestamps
    end
    add_index :nodes, :site_id
    add_index :nodes, :root_site_id
    add_index :nodes, :ancestry
    add_index :nodes, :ancestry_depth
    add_index :nodes, :shortcut
  end
end

