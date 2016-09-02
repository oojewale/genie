class WatsonConversationService
  def self.setup
    convo = JSON.parse(ENV["VCAP_SERVICES"])['conversation'].first['credentials']

    wkspace_id = ENV["CONV_WORKSPACE_ID"]
    url = convo['url'] + '/v1/workspaces/' +wkspace_id + '/message?version=2016-07-11'

    new(url, convo)
  end

  attr_reader :watson_connection, :entities, :intents, :verdict

  def initialize(url, convo)
    @watson_connection = Faraday.new(url: url) do |f|
      f.adapter Faraday.default_adapter
    end
    @watson_connection.basic_auth(convo['username'], convo['password'])
  end

  def prepare_payload(key, txt)
    @payload = { alternate_text: false }
    @key = key
    set_input(txt)
    set_context(key)
  end

  def set_input(txt)
    @payload['input'] = { text: txt }
  end

  def set_context(key)
    stack = get_stack
    ctx = {
      system: {
        dialog_stack: stack.dialog_stack,
        dialog_turn_counter: stack.turn_counter,
        dialog_request_counter: stack.turn_counter,
      }
    }
    ctx["conversation_id"] = stack.convo_id if stack.convo_id
    @payload['context'] = ctx
  end

  def send_to_watson
    r = watson_connection.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Accept'] = 'application/json'
      req.body = @payload.to_json
    end

    pkg = JSON.parse(r.body)
    parse_response(pkg)

    save_context(pkg)
    pkg["output"]["text"].join(", ")
  end

  def parse_response(pkg)
    @entities = pkg["entities"]
    @intents = pkg["intents"]
    @verdict = pkg["output"]
  end

  def save_context(pkg)
    ctx = pkg["context"]["system"]
    stack = pkg["output"]["nodes_visited"]
    turn_counter = ctx["dialog_turn_counter"]
    request_counter = ctx["dialog_request_counter"]
    wID = pkg["conversation_id"]

    ctx = get_stack || ConversationContext.new(key: @key)
    ctx.update_attributes({
               dialog_stack: stack,
               turn_counter: turn_counter,
               request_counter: request_counter,
               convo_id: wID
               }
             )
  end

  def get_stack
    ConversationContext.find_by(key: @key) || ConversationContext.new(key: @key)
  end
end
