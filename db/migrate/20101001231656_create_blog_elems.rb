class CreateBlogElems < ActiveRecord::Migration
  def change
    create_table :blog_elems do |t|
      t.integer :count_limit
      t.date :past_limit
      t.string :display_type
      t.timestamps
    end
  end
end

