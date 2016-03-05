require 'test_helper'

class WebhookTest < ActiveSupport::TestCase
  def test_valid_webhook
    webhook = webhooks(:github_to_slack)
    assert webhook.valid?
  end

  def test_invalid_webhook
    webhook = webhooks(:github_to_idobata)
    assert !webhook.valid?
  end

  def test_from_class
    webhook = webhooks(:github_to_slack)
    assert_equal Webhooks::From::Github, webhook.from_class
  end

  def test_to_class
    webhook = webhooks(:github_to_slack)

    assert_equal Webhooks::To::Slack, webhook.to_class
  end

  def test_run
    Webhooks::To::Slack.any_instance.expects(:post)

    webhook = webhooks(:github_to_slack)
    webhook.run(payload: {'comment' => { 'html_url' => 'http://example.com/issue/1#issuecomment-1', 'body' => '@ppworks 見てください'}})
  end

  def test_run_lack_of_slack
    Webhooks::To::Slack.any_instance.expects(:post).never

    webhook = webhooks(:github_to_slack)
    webhook.run(payload: {'comment' => { 'html_url' => 'http://example.com/issue/1#issuecomment-1', 'body' => '@taea 見てください'}})
  end

  def test_run_lack_of_github
    Webhooks::To::Slack.any_instance.expects(:post).never

    webhook = webhooks(:github_to_slack)
    webhook.run(payload: {'comment' => { 'html_url' => 'http://example.com/issue/1#issuecomment-1', 'body' => '@fukayatsu 見てください'}})
  end
end
