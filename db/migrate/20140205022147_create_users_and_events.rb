class CreateUsersAndEvents < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end

    create_table :events_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :event
    end
  end
end
