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
      meta_data = {
        "frontmatter" => @frontmatter,

        "_generator" => {
          "name" =>  "resume-stylist",
          "version" => ResumeStylist::VERSION
        }

      }
      ctx = resume_data.merge(meta_data)
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

require "resume-stylist/theme/normalize_css"
require "resume-stylist/theme/ordinal_date"
