class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.text :name

      t.timestamps null: false
    end
  end
end
