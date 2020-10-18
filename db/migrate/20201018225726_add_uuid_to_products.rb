# frozen_string_literal: true

class AddUuidToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :uuid, :string
  end
end
