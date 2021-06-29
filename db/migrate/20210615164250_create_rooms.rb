class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.string :title
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
    create_join_table :rooms, :room_options
  end
end
