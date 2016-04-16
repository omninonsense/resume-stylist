module ResumeStylist
  module XMLResume
    def self.handles?(resume_format)
      resume_format.to_s.downcase == "xml"
    end

    def load!(input)
      raise NotImplementedError, "Feature not yet implemented!"
    end
  end
end

ResumeStylist::Resume.register_handler ResumeStylist::XMLResume
