class MakeDefaultAdmin < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :isAdmin, false
  end
end
