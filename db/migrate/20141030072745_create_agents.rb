class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.string :name
      t.string :street
      t.string :zip
      t.string :city
      t.string :opening_hours

      t.timestamps
    end
    add_index :agents, :zip, unique: true
  end
end
