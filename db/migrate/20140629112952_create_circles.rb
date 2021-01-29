class CreateCircles < ActiveRecord::Migration
  def change
    create_table :circles do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
