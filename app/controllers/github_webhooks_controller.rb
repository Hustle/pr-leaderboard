# app/controllers/github_webhooks_controller.rb
class GithubWebhooksController < ActionController::Base

  include GithubWebhook::Processor

  def show
    render json: 'OK'
  end

  def create
    Rails.logger.info("Received event #{json_body}")
    Event.create_unless_exists! json_body
    head(:ok)
  end

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

end
