class CreateBlogElemLinks < ActiveRecord::Migration
  def change
    create_table :blog_elem_links do |t|
      t.belongs_to :blog
      t.belongs_to :blog_elem
    end

    add_index :blog_elem_links, :blog_id
    add_index :blog_elem_links, :blog_elem_id
    add_index :blog_elem_links, [:blog_id, :blog_elem_id]
  end
end
