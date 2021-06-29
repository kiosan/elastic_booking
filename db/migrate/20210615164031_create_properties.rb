class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :title

      t.timestamps
    end
    create_join_table :properties, :property_options
  end
end
