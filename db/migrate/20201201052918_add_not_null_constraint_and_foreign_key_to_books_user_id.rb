class AddNotNullConstraintAndForeignKeyToBooksUserId < ActiveRecord::Migration[6.0]
  def change
    change_column_null :books, :user_id, false
    add_foreign_key :books, :users
  end
end
