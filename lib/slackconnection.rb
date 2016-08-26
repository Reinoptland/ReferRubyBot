class SlackConnection
  def get_dm_channel(data)
    # Get user's DM channel code
    uri = URI("https://slack.com/api/im.open?token=#{ENV['SLACK_API_TOKEN']}&user=#{data.user}")
    # Needs reformatting with names to symbol
    uri_response = JSON.parse(Net::HTTP.get(uri))
    dm_channel = uri_response["channel"]["id"]
    dm_channel
  end

  def broadcast_to_general(message, client)
    uri = URI("https://slack.com/api/channels.list?token=#{ENV['SLACK_API_TOKEN']}")

    # Needs reformatting with names to symbol
    uri_response = JSON.parse(Net::HTTP.get(uri))

    # Assuming #general is always the first item in the channels
    # array. Needs non-hard coded fix
    general_channel = uri_response["channels"][0]["id"]

    client.say(text: message, channel: general_channel)
  end

end
