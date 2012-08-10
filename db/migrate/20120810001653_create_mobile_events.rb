class CreateMobileEvents < ActiveRecord::Migration
  def change
    create_table :mobile_events do |t|
      t.float :latitude
      t.float :longitude
      t.string :event_type
      t.float :timestamp
      t.integer :mobile_session_id
      t.timestamps
    end
  end
end
