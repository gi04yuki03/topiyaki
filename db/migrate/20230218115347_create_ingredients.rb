class CreateIngredients < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredients do |t|
      t.string :ingredient
      t.string :quantity
      t.references :recipe, foreign_key: true
      t.timestamps
    end
  end
end
