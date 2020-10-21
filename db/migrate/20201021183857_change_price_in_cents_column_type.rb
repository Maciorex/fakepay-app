# frozen_string_literal: true

class ChangePriceInCentsColumnType < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :price_in_cents, 'integer USING CAST(price_in_cents AS integer)'
  end
end
