class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :title
      t.text :banner
      t.string :event_color
      t.string :background_color
      t.belongs_to :page
      t.timestamps
    end
    add_index :calendars, :page_id
  end
end
