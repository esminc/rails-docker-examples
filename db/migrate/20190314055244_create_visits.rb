class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.datetime :visited_at

      t.timestamps
    end
  end
end
