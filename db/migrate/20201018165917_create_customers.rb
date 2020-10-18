# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :address
      t.string :zip_code

      t.timestamps
    end
  end
end
