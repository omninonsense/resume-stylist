module ResumeStylist
  module OrdinalDateFilter
    # safe true

    # # For languages with more diverse ordinals (if such even exist)
    # Ordinals = %w{
    #   st nd rd th th th th th th th
    #   th th th th th th th th th th
    #   st nd rd th th th th th th th
    #   st
    # }

    # For English
    Ordinals = Hash.new do |h, k|
      if (11..13).cover? k
        h[k] = "th"
      elsif 1 == (k % 10)
        h[k] = "st"
      elsif 2 == (k % 10)
        h[k] = "nd"
      elsif 3 == (k % 10)
        h[k] = "rd"
      else
        h[k] = "th"
      end
    end

    def ordinal_date(input)
      _day     = input.mday
      _ordinal = Ordinals[_day]
      _month   = Date::MONTHNAMES[input.month]
      _year    = input.year

      day      = %Q|<span class="day">#{_day}</span>|
      ordinal  = %Q|<span class="ordinal">#{_ordinal}</span>|
      month    = %Q|<span class="month">#{_month}</span>|
      year     = %Q|<span class="year">#{_year}</span>|

      html = "#{day}#{ordinal} #{month} #{year}"

      return html
    end
  end
end

Liquid::Template.register_filter(ResumeStylist::OrdinalDateFilter)
