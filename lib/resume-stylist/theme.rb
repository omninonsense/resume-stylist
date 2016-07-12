module ResumeStylist
  class Theme
    # def intialize(theme_path)
      # @source = File.read(theme_path)
    def initialize(source)
      @source = source
      @frontmatter = {
        "flags" => []
      }
      parse_frontmatter!

      @template = Liquid::Template.parse(@source)
    end

    def render(resume_data)
      ctx = resume_data.merge({ "frontmatter" => @frontmatter })
      @resume = @template.render(ctx)
      post_process!

      @resume
    end

    private
    def post_process!
      return if @frontmatter["flags"].include? "disable_post_processing"

      @document = Oga.parse_html @resume

      @document.css(%q{style[type="text/scss"], style[type="text/sass"]}).each do |style|
        syntax = style.get("type")[5, 4].to_sym # Going to be :scss or :sass
        css = Sass::Engine.new(style.text, syntax: syntax, style: :compressed)

        style.inner_text = css.render
        style.set("type", "text/css")
      end

      @resume = @document.to_xml
    end

    private
    def parse_frontmatter!
      if @source =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
        @source = $POSTMATCH
        @frontmatter.merge!(YAML.load($1) || {})
      end

      nil
    end
  end
end

class NormalizeCSS < Liquid::Tag

  NormalizeCSS_URI = URI("https://necolas.github.io/normalize.css/latest/normalize.css")

  def initialize(tag_name, tokens, ctx)
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

Liquid::Template.register_tag('normalize_css', NormalizeCSS)
