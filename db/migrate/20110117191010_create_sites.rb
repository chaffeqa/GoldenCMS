class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :subdomain
      t.string :site_name
      t.boolean :has_inventory, :default => false
      t.text :config_params
      t.text :header
      t.text :footer
      t.timestamps
    end

    add_index :sites, :subdomain
  end
end

