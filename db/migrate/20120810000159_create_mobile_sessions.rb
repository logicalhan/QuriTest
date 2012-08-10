class CreateMobileSessions < ActiveRecord::Migration
  def change
    create_table :mobile_sessions do |t|
      t.boolean :is_validly_completed, default: false
      t.timestamps
    end
  end
end
