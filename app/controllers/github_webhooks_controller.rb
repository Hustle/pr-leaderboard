# app/controllers/github_webhooks_controller.rb
class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor


  def create
    Rails.logger.info("Received event #{json_body}")
    Event.create! data: json_body
  end


  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end
end
