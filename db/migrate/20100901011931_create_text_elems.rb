class CreateTextElems < ActiveRecord::Migration
  def change
    create_table :text_elems do |t|
      t.text :text
      t.belongs_to :element
      t.timestamps
    end
    
    add_index :text_elems, :element_id
  end
end
