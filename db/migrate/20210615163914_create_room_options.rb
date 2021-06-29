class CreateRoomOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :room_options do |t|
      t.string :title

      t.timestamps
    end
  end
end
