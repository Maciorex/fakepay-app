# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :customer, foreign_key: true
      t.references :product, foreign_key: true
      t.string :fakepay_token
      t.date :subscribe_date
      t.date :expiration_date

      t.timestamps
    end
  end
end
