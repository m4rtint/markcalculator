class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name, null:false
      t.float :currentMark, :default => 0
      t.float :weight, null:false, :default => 0.5
      t.references :term, null:false
      t.timestamps null: false
    end
  end
end
