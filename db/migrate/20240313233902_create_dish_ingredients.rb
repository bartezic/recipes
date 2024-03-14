class CreateDishIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :dish_ingredients do |t|
      t.string :name
      t.references :dish, null: false, foreign_key: true, index: true
      t.references :ingredient, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
