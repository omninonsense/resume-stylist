module Jsonresume
  module Stylist
    class Theme
      def intialize(theme_path)
        @template = Liqud::Template.parse(File.read(theme_path))
        parse_frontmatter!
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
        @document.css(%q{style[lang="text/scss"]}).each do |style|

        end
      end

      private
      def parse_frontmatter!
      if @template =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
        @template = $POSTMATCH
        @frontmatter = YAML.load($1)
      end

      nil
    end

      private
      def compile_scss(source)

      end

      private
      def compile_sass(source)

      end
    end
  end
end
