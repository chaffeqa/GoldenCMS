class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :position
      t.integer :page_area
      t.string :title
      t.boolean :display_title, :default => true
      t.string :html_id
      t.string :html_class
      t.boolean :cachable
      t.belongs_to :node
      t.timestamps
    end

    add_index :elements, :node_id
    add_index :elements, [:node_id, :page_area, :position]
  end
end
