require 'json'
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

file = File.open("#{Rails.root}/db/recipes.json")

@recipes = JSON.load(file)

file.close

def strip_ingredient(ingredient)
  # TODO - this rejex should be improved to clean ingredient names as much as possible
  ingredient.gsub(/(\d+|(½|⅓|¼|⅔|¾| cups?| teaspoons?| tablespoons?| sliced| trimmed| thawed| cut into *| divided| or to taste| thinly sliced| chopped| drained| finely| or more to taste| or as needed| or as desired| cooled|\(.? ounce\)))/,"").strip
end

@recipes.each do |recipe|
  print "."
  category_id = Category.find_or_create_by!(name: recipe['category']).id if recipe['category']
  author_id = Author.find_or_create_by!(name: recipe['author']).id if recipe['author']
  dish_ingredients = recipe['ingredients'].map do |ingredient|
    DishIngredient.build({
      name: ingredient,
      ingredient_id: Ingredient.find_or_create_by!(name: strip_ingredient(ingredient)).id
    })
  end

  Dish.create!({
    name: recipe['title'],
    image: recipe['image'],
    cook_time: recipe['cook_time'],
    prep_time: recipe['prep_time'],
    ratings: recipe['ratings'],
    
    category_id: category_id,
    author_id: author_id,
    dish_ingredients: dish_ingredients
  })
end; 0


#   rails g model Category name:string
#   rails g model Author name:string
#   rails g model Dish name:string cook_time:integer prep_time:integer ratings:decimal category:references author:references
#   rails g model Ingredient name:string
#   rails g model DishIngredient name:string dish:references ingredient:references capacity:integer capacity_unit:integer

#   rails g model Table name:string
#   rails g model TableIngredient name:string table:references ingredient:references capacity:integer capacity_unit:integer.gsub!(/(\d+|(min))/,"")