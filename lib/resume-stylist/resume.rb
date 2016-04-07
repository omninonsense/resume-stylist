require "resume-stylist/resume/json.rb"
require "resume-stylist/resume/xml.rb"

module ResumeStylist
  class Resume
    attr_accessor :name, :label, :picture, :email, :phone, :website,
    attr_accessor :address
    attr_accessor :profiles
    attr_accessor :experiences

    #@XXX: Remove summary, since it's kind of redundant on a CV?
    attr_accessor :summary

    class Address
      attr_accessor :address, :postalCode, :city, :countryCode, :region
    end

    class Profile
      attr_accessor :network_name, :username, :url
    end

    class Experience
      attr_accessor :company, :position, :website, :summary, :highlights
      attr_accessor :startDate, :endDate
    end

    class Experience
      attr_accessor :organisation, :position, :website, :summary, :highlights
      attr_accessor :startDate, :endDate
      attr_accessor :volunteer
    end

    class Education
      attr_accessor :institution, :area, :studyType, :grade, :courses
      attr_accessor :startDate, :endDate
    end

    #@XXX: This seems like an odd thing to have IMHO, but whatevs.
    class Award
      attr_accessor :title, :date, :awarder, :summary
    end

    class Publication
      attr_accessor :name, :publisher, :releaseDate, :website, :summary
    end

    class Skill
      attr_accessor :name, :level
    end

    class Language
      attr_accessor :name, :level
    end

    class Interest
      attr_accessor :name, :keywords

    end

    class Reference
      attr_accessor :name, :reference
    end
  end
end
