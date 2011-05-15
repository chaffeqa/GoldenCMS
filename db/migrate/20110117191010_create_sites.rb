class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :subdomain
      t.boolean :has_inventory, :default => false
      t.belongs_to :node
      t.string :site_name
      t.timestamps
    end

    add_index :sites, :subdomain
    add_index :sites, :node_id
  end

  def self.down
    remove_index :sites, :subdomain
    remove_index :sites, :node_id
    drop_table :sites
  end
end

