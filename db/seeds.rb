User.create!([
  {first_name: "Daniel", last_name: "Mai Trong", email: "daniel@gmail.com", password_digest: "$2a$10$vyo0uV.ZJDSlii7RukClYe39bLCvCKYZ18uLrJh0jAeqxKtyahcei"},
  {first_name: "Luna", last_name: "Tran", email: "luna@gmail.com", password_digest: "$2a$10$wzGUF3ubrp4186iq8vCVFeKU3xx4JZBm9nk9ahvHLFppvoKvGqOge"}
])

Category.create!([
  {name: "Food"},
  {name: "Housing"},
  {name: "Medical"},
  {name: "Savings"},
  {name: "Transportation"},
  {name: "Taxes"},
  {name: "Other"}
])

Budget.create!([
  {name: "default_budget", user_id: 1}
])
BudgetCategory.create!([
  {budget_id: 1, category_id: 1},
  {budget_id: 1, category_id: 2},
  {budget_id: 1, category_id: 3},
  {budget_id: 1, category_id: 4},
  {budget_id: 1, category_id: 5},
  {budget_id: 1, category_id: 6},
  {budget_id: 1, category_id: 7}
])
Percentage.create!([
  {percentage: 0.3},
  {percentage: 0.05},
  {percentage: 0.1},
  {percentage: 0.12},
  {percentage: 0.07},
  {percentage: 0.06},
  {percentage: 0.3}
])

CategoryPercentage.create!([
  {category_id: 1, percentage_id: 4},
  {category_id: 2, percentage_id: 3},
  {category_id: 3, percentage_id: 2},
  {category_id: 4, percentage_id: 6},
  {category_id: 5, percentage_id: 5},
  {category_id: 6, percentage_id: 1},
  {category_id: 7, percentage_id: 7}
])


