class CreateDynamicPages < ActiveRecord::Migration
  def change
    create_table :dynamic_pages do |t|
      t.string :template_name
      t.integer :positions
      t.belongs_to :node
      t.timestamps
    end
    
    add_index :dynamic_pages, :node_id
  end
end
