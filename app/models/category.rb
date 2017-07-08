class Category < ApplicationRecord
  has_many :budget_categories
  has_many :budgets, through: :budget_categories

  has_many :category_percentages
  has_many :percentages, through: :category_percentages
end
