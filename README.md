# Resume Stylist

**Note**: Currently in very early development.

Small framework for making CV/resume themes using [liquid](https://github.com/Shopify/liquid/wiki/liquid-for-designers) and [scss](http://sass-lang.com/).

## Installation

~~~sh
$ gem install resume-stylist
~~~

Also, since this uses PDFKit, you'll need to make sure you have `wkhtmltopdf` installed. On Arch it's as simple as running `sudo pacman -S wkhtmltopdf`, but consult their documentation for recommendations regarding other platforms: https://github.com/pdfkit/pdfkit#wkhtmltopdf


## Usage

### Tool usage

Create a new theme and a JSON resume template:

~~~sh
$ resume-stylist --new-theme fancy.html.liquid --new-resume john_doe.json
~~~

Build your theme as a PDF:

~~~sh
$ resume-stylist build john_doe.json john_doe.pdf
~~~

~~~sh
$ resume-stylist build john_doe -I json john_doe.pdf
~~~

Run `resume-stylist --help` for more options!

### Library usage

#### Registering a custom resume format

~~~rb
module MyResumeFormat
  def self.handles?(resume_format)
    # Handle
    resume_format.to_s =~ /(myformat|myf)/i
  end

  def load!(input)
    # input is the resume data
    data = My::Parser.parse(input)
    @data = data.to_h
  end
end

ResumeStylist::Resume.register_handler MyResumeFormat
~~~

**NOTE**: The theme expects `@data` to be a `Hash` with `String` keys.

#### Creating a resume (HTML) programmatically:

~~~rb
resume = ResumeStylist::Resume.new(resume_source, :myformat)
theme = ResumeStylist::Theme.new(theme_source)

html = theme.render(resume.data)
~~~

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/omninonsense/resume-stylist. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
