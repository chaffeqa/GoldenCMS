class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.belongs_to :blog
      t.datetime :post_date
      t.timestamps
    end

    add_index :posts, :blog_id
    add_index :posts, [:blog_id, :post_date]
  end

  def self.down
    remove_index :posts, :blog_id
    remove_index :posts, [:blog_id, :post_date]
    drop_table :posts
  end
end
