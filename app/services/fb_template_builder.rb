class FbTemplateBuilder
    def self.build(type, msg)
        send(type, meg)
    end

    def self.default(msg)
        { text: msg }
    end

    def self.image(image_url)
      {
        attachment:{
          type:"image",
          payload:{
            url: image_url
          }
        }
      }
    end

    def self.generic(user_name, image_url)
      {
        attachment:{
          type: "template",
          payload:{
            template_type: "generic",
            elements: [
              {
                title:"Hello #{user_name}. Nice pics",
                image_url: image_url,
                subtitle:"How are you doing today?",
                buttons:[
                  {
                    type:"postback",
                    payload:"true",
                    title:"Great"
                  },
                  {
                    type:"postback",
                    title:"Kinda..",
                    payload:"false"
                  }
                ]
              }
            ]
          }
        }
      }
  end
end
