require 'test_helper'

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  def github_payloads(type)
    JSON.parse(YAML.load_file("#{Rails.root}/test/payloads/github_payloads.yml")[type.to_s]['body'])
  end

  def test_hook_with_wrong_token
    assert_raises(ActiveRecord::RecordNotFound) do
      post '/webhooks/undefined'
    end
  end

  def test_hook_from_github_commit_comment
    webhook = webhooks(:github_to_slack)
    payload = github_payloads(:commit_comment)

    post "/webhooks/#{webhook.token}", params: payload
    assert_response :success
  end

  def test_hook_from_github_issue_commit_comment
    webhook = webhooks(:github_to_slack)
    payload = github_payloads(:issue_comment)

    post "/webhooks/#{webhook.token}", params: payload
    assert_response :success
  end

  def test_hook_from_github_pull_request
    webhook = webhooks(:github_to_slack)
    payload = github_payloads(:pull_request)

    post "/webhooks/#{webhook.token}", params: payload
    assert_response :success
  end
end
