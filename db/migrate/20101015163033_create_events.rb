class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, :default => false
      t.string :color
      t.belongs_to :node    
      t.timestamps
    end

    add_index :events, :node_id
    add_index :events, [:start_at, :end_at]
  end
end
