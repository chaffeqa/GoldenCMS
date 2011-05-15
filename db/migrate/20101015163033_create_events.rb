class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, :default => false
      t.string :color
      t.belongs_to :calendar      
      t.timestamps
    end

    add_index :events, :calendar_id
    add_index :events, [:start_at, :end_at]
    add_index :events, [:calendar_id, :start_at, :end_at]
  end

  def self.down
    remove_index :events, :calendar_id
    remove_index :events, [:start_at, :end_at]
    remove_index :events, [:calendar_id, :start_at, :end_at]
    drop_table :events
  end
end
