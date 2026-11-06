class CreateTrailAtlasData < ActiveRecord::Migration[8.1]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :province, null: false, default: "Ontario"
      t.string :country, null: false, default: "Canada"
      t.string :source_name, null: false
      t.decimal :latitude, precision: 9, scale: 6, null: false
      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.timestamps
    end
    add_index :regions, :name, unique: true

    create_table :parks do |t|
      t.references :region, null: false, foreign_key: true
      t.string :name, null: false
      t.string :park_type, null: false
      t.text :description, null: false
      t.string :website_url
      t.string :source_name, null: false
      t.boolean :accessible, null: false, default: false
      t.decimal :latitude, precision: 9, scale: 6, null: false
      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.timestamps
    end
    add_index :parks, %i[region_id name], unique: true

    create_table :trails do |t|
      t.references :park, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description, null: false
      t.string :difficulty, null: false
      t.string :surface, null: false
      t.decimal :distance_km, precision: 6, scale: 2, null: false
      t.integer :elevation_gain_m, null: false, default: 0
      t.string :source_name, null: false
      t.decimal :latitude, precision: 9, scale: 6, null: false
      t.decimal :longitude, precision: 9, scale: 6, null: false
      t.timestamps
    end
    add_index :trails, %i[park_id name], unique: true
    add_index :trails, :difficulty

    create_table :tags do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true

    create_table :activities do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.timestamps
    end
    add_index :activities, :name, unique: true

    create_table :trail_tags do |t|
      t.references :trail, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :trail_tags, %i[trail_id tag_id], unique: true

    create_table :trail_activities do |t|
      t.references :trail, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.timestamps
    end
    add_index :trail_activities, %i[trail_id activity_id], unique: true
  end
end
