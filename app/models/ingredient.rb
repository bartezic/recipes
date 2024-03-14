class Ingredient < ApplicationRecord
  has_many :dish_ingredients
  has_and_belongs_to_many :dishes, through: :dish_ingredients
end
