class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @webhook = Webhook.find_by!(token: params[:token])
    @webhook.run(payload: params)
    head :no_content
  end
end
