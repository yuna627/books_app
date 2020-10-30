class AddNotNullToBooksTitle < ActiveRecord::Migration[6.0]
  def change
    change_column_null(:books, :title, false)
  end
end
