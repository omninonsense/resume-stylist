module ResumeStylist
  class NormalizeCSS < Liquid::Tag

    NormalizeCSS_URI = URI("https://necolas.github.io/normalize.css/latest/normalize.css")

    def initialize(tag_name, tokens, liq)
      if tokens.include? "inline"
        req = Net::HTTP::Get.new(NormalizeCSS_URI.request_uri)

        http = Net::HTTP.new(NormalizeCSS_URI.host, NormalizeCSS_URI.port)
        http.use_ssl = (NormalizeCSS_URI.scheme == "https")

        response = http.request(req)

        if response.code == "200"
          @content = response.body
        else
          @content = "/*! ERROR: Request for `#{NormalizeCSS_URI}` returned #{response.code}! Please report this bug at https://github.com/omninonsense/resume-stylist/issues/new */"
        end
      else
        @content = %Q{<link rel="stylesheet" href="#{NormalizeCSS_URI}" media="screen">}
      end
    end

    def render(context)
      @content
    end
  end
end

Liquid::Template.register_tag('normalize_css', ResumeStylist::NormalizeCSS)
