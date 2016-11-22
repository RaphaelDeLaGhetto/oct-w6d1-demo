class ChangeCachesTable < ActiveRecord::Migration
  def change
    remove_column :caches, :days_ago
    add_reference :caches, :user
  end
end