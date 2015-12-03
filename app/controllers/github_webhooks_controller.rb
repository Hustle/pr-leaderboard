# app/controllers/github_webhooks_controller.rb
class GithubWebhooksController < ActionController::Base

  before_filter :log_info

  include GithubWebhook::Processor


  def show
    render json: 'OK'
  end


  def create
    Rails.logger.info("Create called")
    Rails.logger.info("Received event #{json_body}")
    Event.create! data: json_body
  end

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

  def log_info
    Rails.logger.info("logging working")
  end
end
