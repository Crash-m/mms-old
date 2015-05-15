class AddPoweruserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :poweruser, :boolean
  end
end
