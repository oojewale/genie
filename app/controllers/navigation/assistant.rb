module Navigation
  class Assistant
    attr_reader :result, :gmaps

    def initialize
      @gmaps = GoogleMapsService::Client.new
    end

    def parse
      Parser.new(result)
    end

    def directions(from, to)
      @result = gmaps.directions(from, to, alternatives: false)
    end

    def get_image_url
      url = build_image_query_url(result.first[:overview_polyline][:points])
      Cloudinary::Uploader.upload(url)["secure_url"]
    end

    def build_image_query_url(polyline)
      url = "https://maps.googleapis.com/maps/api/staticmap?"
      url += "size=600x600&"
      url += "scale=2&"
      url += "maptype=roadmap&"
      url += "path=enc:#{polyline}&"
      url += "key=#{ENV['GMAPS_KEY']}"
      url
    end
  end
end
