class AddGithubCreatedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :github_created_at, :datetime
    add_index :events, :github_created_at
  end
end
