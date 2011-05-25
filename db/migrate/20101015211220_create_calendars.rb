class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :title
      t.text :banner
      t.string :event_color
      t.string :background_color
      t.belongs_to :node
      t.timestamps
    end
    add_index :calendars, :node_id
  end
end
