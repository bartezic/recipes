class HomeController < ApplicationController
  def index
    @matched_dishes = ingredients.any? ? match_dishes : Dish.none
  end

  private

  def ingredients
    params[:ingredients] && params[:ingredients].split(',').map(&:strip).map(&:downcase).map{|i| "%#{i}%"} || []
  end

  def match_dishes
    # Simple JOIN to just return dish with ingredients
    # Dish.find_by_sql(
    #   <<-SQL
    #     SELECT dishes.*,
    #     FROM dishes
    #     JOIN dish_ingredients ON dishes.id = dish_ingredients.dish_id
    #     JOIN ingredients ON dish_ingredients.ingredient_id = ingredients.id
    #     WHERE ingredients.name LIKE ANY (array['#{ingredients.join("\',\'")}'])
    #     GROUP BY dishes.id
    #     LIMIT 10
    #   SQL
    # )

    # More complex solution with possibility to filter matched_ingredients_count equal total_dish_ingredients_count
    Dish.find_by_sql(
      <<-SQL
        SELECT
          dishes.*,
          #{ingredients.map{|i| "COUNT(CASE WHEN ingredients.name LIKE '#{i}' THEN 1 END)"}.join('+')} AS matched_ingredients_count,
          COUNT(dish_ingredients.*) AS total_dish_ingredients_count
        FROM dishes
        JOIN dish_ingredients ON dishes.id = dish_ingredients.dish_id
        JOIN ingredients ON dish_ingredients.ingredient_id = ingredients.id
        WHERE dishes.id IN (
          SELECT DISTINCT d.id
          FROM dishes d
          JOIN dish_ingredients di ON d.id = di.dish_id
          JOIN ingredients i ON di.ingredient_id = i.id
          WHERE i.name LIKE ANY (array['#{ingredients.join("\',\'")}'])
        )
        GROUP BY dishes.id
        ORDER BY matched_ingredients_count DESC
        LIMIT 10
      SQL
    )
  end
end
