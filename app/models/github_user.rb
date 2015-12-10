class GithubUser < ActiveRecord::Base

  serialize :data, HashSerializer

  before_save :set_login
  before_save :set_github_id

  def self.create_unless_exists!(github_id)
    GithubUser.create!(data: $github_client.user(github_id).to_attrs) unless GithubUser.where(github_id: github_id).exists?
  end

  private

  def set_login
    self.login = data.login
  end

  def set_github_id
    self.github_id = data.id
  end

end
