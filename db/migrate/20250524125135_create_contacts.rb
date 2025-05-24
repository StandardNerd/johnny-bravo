class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :preferred_call_time, null: false
      t.text :message, null: false
      t.boolean :spam, default: false
      t.timestamps
    end
    
    add_index :contacts, :email
    add_index :contacts, :phone
    add_index :contacts, :preferred_call_time
    add_index :contacts, :created_at
    add_index :contacts, :spam
  end
end
