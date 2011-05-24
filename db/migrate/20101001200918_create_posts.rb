class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :post_date
      t.belongs_to :blog
      t.timestamps
    end

    add_index :posts, :blog_id
    add_index :posts, [:blog_id, :post_date]
  end
end
