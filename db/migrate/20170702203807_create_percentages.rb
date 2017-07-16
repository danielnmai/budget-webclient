class CreatePercentages < ActiveRecord::Migration[5.1]
  def change
    create_table :percentages do |t|
      t.float :percentage
      t.timestamps
    end
  end
end
