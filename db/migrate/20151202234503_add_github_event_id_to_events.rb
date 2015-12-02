class AddGithubEventIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :github_id, :string, null: false
    add_index :events, :github_id, unique:true
  end
end
