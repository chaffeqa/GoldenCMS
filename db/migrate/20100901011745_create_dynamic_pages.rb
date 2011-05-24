class CreateDynamicPages < ActiveRecord::Migration
  def change
    create_table :dynamic_pages do |t|
      t.belongs_to :node
      t.integer :positions
      t.timestamps
    end
    
    add_index :dynamic_pages, :node_id
  end
end
