class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :position
      t.integer :element_area
      t.string :title
      t.boolean :display_title, :default => true
      t.string :html_id
      t.string :html_class
      t.boolean :cachable
      t.belongs_to :page
      t.timestamps
    end

    add_index :elements, :page_id
    add_index :elements, [:page_id, :element_area, :position]
  end
end
