require 'googl'
require 'liquid'

module Feedbook
  module LiquidExtensions
    module Filters
      class GooglShortenerFilter
        def googl(input)
          url = Googl.shorten(input)
          url.short_url
        end
      end
    end
  end
end

Liquid::Template.register_filter(Feedbook::LiquidExtensions::Filters::GooglShortenerFilter)