class Percentage < ApplicationRecord
  has_many :category_percentages
  has_many :categories, through: :category_percentages
end
