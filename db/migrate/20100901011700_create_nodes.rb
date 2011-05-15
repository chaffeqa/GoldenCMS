class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :title
      t.string :menu_name
      t.string :shortcut
      t.belongs_to :parent
      t.integer :site_id
      t.boolean :displayed
      t.references :page, :polymorphic => true
      t.string :controller
      t.string :action
      t.integer :position
      t.string :layout
      t.timestamps
    end

    add_index :nodes, :parent_id
    add_index :nodes, :site_id
    add_index :nodes, [:parent_id, :position]
    add_index :nodes, [:shortcut, :site_id]
    add_index :nodes, :shortcut
    add_index :nodes, [:page_id, :page_type]
  end

  def self.down
    remove_index :nodes, :parent_id
    remove_index :nodes, :site_id
    remove_index :nodes, [:parent_id, :position]
    remove_index :nodes, [:shortcut, :site_id]
    remove_index :nodes, :shortcut
    remove_index :nodes, [:page_id, :page_type]
    drop_table :nodes
  end
end

