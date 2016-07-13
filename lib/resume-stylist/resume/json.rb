module ResumeStylist
  module JSONResume

    def self.date_helper(d)
      return unless d

      date ||= (Date.strptime(d, '%Y-%m-%d') rescue nil)
      date ||= (Date.strptime(d, '%Y-%m')    rescue nil)
      date ||= (Date.strptime(d, '%Y')       rescue nil)

      return date
    end

    def self.downcase_keys_helper(h)
      case h
      when Hash
        h = h.dup
        h.keys.each do |key|
          new_key = key.downcase
          val = h.delete(key)
          h[new_key] = downcase_keys_helper(val)
        end
      when Array
        return h.map {|e| downcase_keys_helper(e) }
      end

      return h
    end

    def self.handles?(resume_format)
      resume_format.to_s.downcase == "json"
    end

    def load!(input)
      data = Yajl::Parser.parse(input)

      # Fix dates, since they're just strings now
      [ data["work"], data["volunteer"], data["education"] ].each do |set|
        set.each do |e|
          e["startDate"] = JSONResume.date_helper(e["startDate"])
          e["endDate"] = JSONResume.date_helper(e["endDate"])
        end
      end

      data["publications"].each {|e| e["releaseDate"] = JSONResume.date_helper(e["releaseDate"]) }
      data["awards"].each {|e| e["date"] = JSONResume.date_helper(e["date"]) }

      @data = JSONResume.downcase_keys_helper(data)
    end
  end
end

ResumeStylist::Resume.register_handler ResumeStylist::JSONResume
