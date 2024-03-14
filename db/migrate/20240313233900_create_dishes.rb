class CreateDishes < ActiveRecord::Migration[7.1]
  def change
    create_table :dishes do |t|
      t.string :name
      t.integer :cook_time
      t.integer :prep_time
      t.decimal :ratings
      t.string :image
      t.references :category, null: false, foreign_key: true, index: true
      t.references :author, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
