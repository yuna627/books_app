# frozen_string_literal: true

class AddIntroductionToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :introduction, :string
  end
end
