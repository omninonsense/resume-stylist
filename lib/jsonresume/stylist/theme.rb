module Jsonresume
  module Stylist
    class Theme
      def intialize(theme_path)
        @source = File.read(theme_path)
        parse_frontmatter!

        @template = Liqud::Template.parse(@source)
      end

      def render(resume_data)
        @resume = @template.render(resume_data)
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

          tnode = Oga::XML::Text.new
          tnode.text = css.render

          style.children = [ tnode ]
          style.set("type", "text/css")
        end

        @resume = @document.to_xml
      end

      private
      def parse_frontmatter!
        if @source =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          @source = $POSTMATCH
          @frontmatter = YAML.load($1)
        end

        nil
      end
    end
  end
end
