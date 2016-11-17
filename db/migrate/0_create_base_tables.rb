class CreateBaseTables < ActiveRecord::Migration

  def change
    create_table :caches do |t|
      t.string :description
      t.string :coordinates
      t.string :image
      t.integer :days_ago
      t.timestamps
    end

  end

end