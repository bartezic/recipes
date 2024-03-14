class Dish < ApplicationRecord
  belongs_to :category
  belongs_to :author
  has_many :dish_ingredients
  has_and_belongs_to_many :ingredients, through: :dish_ingredients

  attr_accessor :matched_ingredients_count, :total_dish_ingredients_count

end
