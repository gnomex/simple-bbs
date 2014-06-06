class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name, null: false
      t.boolean :admin, null: false, default: true

      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
