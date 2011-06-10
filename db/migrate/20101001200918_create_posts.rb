class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :post_date
      t.belongs_to :page
      t.timestamps
    end
    add_index :posts, :page_id
  end
end
