class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.integer :github_id, null: false
      t.jsonb :data, null: false, default: {}
      t.string :login, null: false
      t.timestamps null: false
    end
    add_index :github_users, :github_id, unique: true
    add_index :github_users, :login, unique: true
  end
end
