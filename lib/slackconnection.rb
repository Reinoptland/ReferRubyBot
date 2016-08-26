class SlackConnection
  def get_dm_channel(data)
    # Get user's DM channel code
    uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")
    # Needs reformatting with names to symbol
    uri_response = JSON.parse(Net::HTTP.get(uri))
    dm_channel = uri_response["channel"]["id"]
    dm_channel
  end
end
