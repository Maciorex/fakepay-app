# frozen_string_literal: true

class CreateProductTable < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :price
      t.string :valid_for

      t.timestamps
    end
  end
end
