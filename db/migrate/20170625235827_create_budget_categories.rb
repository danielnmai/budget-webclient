class CreateBudgetCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :budget_categories do |t|
      t.integer :budget_id
      t.integer :category_id

      t.timestamps
    end
  end
end
