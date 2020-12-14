class CreateKeyChecker < ActiveRecord::Migration[6.0]
  def change
    create_table :keys do |t|
      t.string :key
    end
  end
end
