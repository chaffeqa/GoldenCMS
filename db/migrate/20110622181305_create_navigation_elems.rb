class CreateNavigationElems < ActiveRecord::Migration
  def change
    create_table :navigation_elems do |t|
      t.string :display_type
      t.string :special_class
      t.belongs_to :element
      t.timestamps
    end
    add_index :navigation_elems, :element_id
  end
end
