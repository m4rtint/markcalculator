class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :courseItem, null: false
      t.float :worth, null:false
      t.float :mark, null:false
      t.float :courseMark, null:false
      t.references :subject, null:false
      t.timestamps null: false
    end
  end
end
