class AddColumnToReadings < ActiveRecord::Migration[5.2]
  def change
    add_column :readings, :reading_id, :string
  end
end
