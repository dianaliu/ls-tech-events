class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :event_type, :default => 'Conference'
      t.string :location
      t.date :start_date
      t.date :end_date
      t.string :twitter_handle
      t.string :website_url
      t.string :logo

      t.timestamps
    end
  end
end
