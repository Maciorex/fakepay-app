# frozen_string_literal: true

class RenameAndAddMissingColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :valid_for
    rename_column :products, :price, :price_in_cents

    add_column :subscriptions, :next_payment_date, :date
  end
end
