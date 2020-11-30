# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title, null: false
      t.text :memo
      t.integer :user_id

      t.timestamps
    end
  end
end
