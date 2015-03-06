class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :email
      t.string :symbol
      t.string :price
    end
  end
end
