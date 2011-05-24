class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :title
      t.text :banner
      t.string :event_color
      t.string :background_color
      t.timestamps
    end
  end
end
