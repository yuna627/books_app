# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.string :body, null: false
      t.integer :user_id

      t.timestamps
    end
  end
end
