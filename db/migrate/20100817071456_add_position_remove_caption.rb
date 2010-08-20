class AddPositionRemoveCaption < ActiveRecord::Migration
  def self.up
    remove_column :gallery_items, :caption
    add_column    :gallery_items, :position, :integer, :default => 0
  end

  def self.down
    add_column    :gallery_items, :caption, :string, :limit => 255
    remove_column :gallery_items, :position
  end
end
