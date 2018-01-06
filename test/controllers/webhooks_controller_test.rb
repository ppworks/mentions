require 'test_helper'

class WebhooksControllerTest < ActionController::TestCase
  def test_hook_with_wrong_token
    assert_raises(ActiveRecord::RecordNotFound) do
      post :create, params: { token: 'undefined' }
    end
  end

  def test_hook_from_github_and_new_by_env
    ENV['GITHUB_TO_SLACK_TOKEN'] = 'env_token'
    event = "commit_comment"
    payload = YAML.load_file("#{Rails.root}/test/payloads/github_payloads.yml")[event]['body']
    post :create, params: { token: 'env_token' }, body: payload
    assert_response :success
    ENV.delete('GITHUB_TO_SLACK_TOKEN')
  end

  def test_hook_from_github
    %w(commit_comment
       issue_comment
       pull_request
       issues
       pull_request_review_comment).each do |event|

      webhook = webhooks(:github_to_slack)
      payload = YAML.load_file("#{Rails.root}/test/payloads/github_payloads.yml")[event]['body']

      post :create, params: { token: webhook.token }, body: payload
      assert_response :no_content
    end
  end

  def test_hook_from_trello
    %w(comment_card).each do |event|

      webhook = webhooks(:trello_to_slack)
      payload = YAML.load_file("#{Rails.root}/test/payloads/trello_payloads.yml")[event]['body']

      head :show, params: { token: webhook.token }, body: payload
      assert_response :ok

      post :create, params: { token: webhook.token }, body: payload
      assert_response :no_content
    end
  end
end
