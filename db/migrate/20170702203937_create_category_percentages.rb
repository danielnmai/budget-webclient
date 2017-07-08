class CreateCategoryPercentages < ActiveRecord::Migration[5.1]
  def change
    create_table :category_percentages do |t|
      t.integer :category_id
      t.integer :percentage_id

      t.timestamps
    end
  end
end
