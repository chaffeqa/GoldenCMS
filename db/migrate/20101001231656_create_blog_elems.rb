class CreateBlogElems < ActiveRecord::Migration
  def change
    create_table :blog_elems do |t|
      t.integer :count_limit
      t.date :past_limit
      t.string :display_type
      t.belongs_to :element
      t.timestamps
    end
    add_index :blog_elems, :element_id
  end
end

