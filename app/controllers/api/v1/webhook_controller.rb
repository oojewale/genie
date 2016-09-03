class Api::V1::WebhookController < Api::V1::ConversationsController
  def verify
    if (params['hub.mode'] == 'subscribe' && params['hub.verify_token'] == "VALIDATION_TOKEN")
      render json: params['hub.challenge']
    else
      head 403
    end
  end

  def handler
    if params["object"] == "page"
      params["entry"].each do |field|
        page_id = field["id"]
        if field["postback"]
          fb_user_id = '' #message["sender"]["id"]
          reply = "Got your postback"
        else
          field["messaging"].each do |message|
            msg = message["message"][:text]
            return unless msg
            fb_user_id = message["sender"]["id"]#get_user(message)
            user = get_user_info(fb_user_id)

            @watson.prepare_payload(fb_user_id, msg)
            @watson.add_context_field('username', user["first_name"])
            reply = @watson.send_to_watson

            make_request(fb_user_id, FbTemplateBuilder.image(@watson.image)) if @watson.image
          end
        end
        reply.split("\n").reject{|val| val.empty? }.in_groups_of(3, false).each {|group| make_request(fb_user_id, FbTemplateBuilder.default(group.join('\n')))}
      end
    end

    head 200
  end

  private

  def get_user_info(user_id)
    profile_url = "https://graph.facebook.com/v2.6/#{user_id}?\
    fields=first_name,last_name,profile_pic,locale,gender&access_token=" + token

    response = Faraday.get(profile_url)
    JSON.parse(response.body)
  end

  def make_request(user_id, message)
    response = {
      recipient: { id: user_id },
      message: message
    }

    uri = 'https://graph.facebook.com/v2.6/me/messages'
    uri += '?access_token=' + token

    stat = Faraday.new(url: uri).post do |req|
      req.body = response.to_json
      req.headers['Content-Type'] = 'application/json'
    end
  end

  def token
    ENV["FB_ACCESS_TOKEN"]
  end
end
