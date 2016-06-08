class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name, default: Time.now.year
      t.references :user, null:false
      t.timestamps null: false
    end
  end
end
