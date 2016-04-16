module ResumeStylist
  class UnsuportedFormatError < StandardError
    # No body
  end

  class Resume
    Handlers = []

    def self.register_handler(handler)
      Handlers << handler
    end

    attr_accessor :data

    def initialize(input, resume_format)
      @data = {
        "name" =>          "",
        "label" =>         "",
        "picture" =>       "",
        "email" =>         "",
        "phone" =>         "",
        "website" =>       "",
        "summary" =>       "",

        "location" => {
          "address" => nil,
          "postalCode" => nil,
          "city" => nil,
          "countryCode" => nil,
          "region" => nil
        },

        "profiles" =>      [], # { network_name, username, url }
        "work" =>          [], # { organisation, position, website, summary, highlights => [], startDate, endDate }
        "volunteer" =>     [], # { organisation, position, website, summary, highlights => [], startDate, endDate }
        "education" =>     [], # { institution, area, studyType, grade, courses => [], startDate, endDate }
        "publications" =>  [], # { name, publisher, releaseDate, website, summary }
        "skill" =>         [], # { name, level }
        "language" =>      [], # { name, level }
        "reference" =>     [], # { name, reference }

        # @XXX: Remove these?
        "awards" =>        [], # { title, date, awarder, summary }
        "interests" =>     []  # { name, keywords }
      }

      if handler = Handlers.find {|h| h.handles? resume_format }
        handler.instance_method(:load!).bind(self).call(input)
      else
        raise UnsuportedFormatError, "`#{resume_format.to_s}` is not a valid format"
      end

    end
  end
end

require "resume-stylist/resume/json.rb"
require "resume-stylist/resume/xml.rb"
