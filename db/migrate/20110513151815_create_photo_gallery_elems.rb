class CreatePhotoGalleryElems < ActiveRecord::Migration
  def change
    create_table :photo_gallery_elems do |t|
      t.string :display_type
      t.integer :max_width
      t.integer :max_height
      t.string :transition_effect
      t.string :effect_speed
      t.integer :interval_seconds
      t.boolean :resize

      t.timestamps
    end
  end
end
