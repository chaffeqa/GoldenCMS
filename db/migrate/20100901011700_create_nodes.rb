class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :title
      t.string :menu_name
      t.string :title
      t.string :shortcut
      t.string :displayed
      t.string :layout
      t.integer :position
      t.string :ancestry
      t.belongs_to :site_scope
      t.belongs_to :parent
      t.belongs_to :site
      t.timestamps
    end
    add_index :nodes, :parent_id
    add_index :nodes, [:parent_id, :position]
    add_index :nodes, :site_id
    add_index :nodes, :site_scope_id
    add_index :nodes, :ancestry
    add_index :nodes, :shortcut
  end
end

