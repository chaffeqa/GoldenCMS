class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :position
      t.integer :page_area
      t.string :title
      t.boolean :display_title, :default => true
      t.string :html_id
      t.belongs_to :dynamic_page
      t.timestamps
    end

    add_index :elements, :dynamic_page_id
    add_index :elements, [:dynamic_page_id, :page_area, :position]
  end
end
