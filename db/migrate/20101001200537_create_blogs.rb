class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :banner
      t.belongs_to :page
      t.timestamps
    end
    add_index :blogs, :page_id
  end
end
