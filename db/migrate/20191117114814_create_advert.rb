class CreateAdvert < ActiveRecord::Migration[5.2]
  def change
    create_table :adverts do |t|
      t.string :name
      t.string :title
      t.text :description, scale: 2
      t.decimal :price

      t.timestamps
    end
  end
end
