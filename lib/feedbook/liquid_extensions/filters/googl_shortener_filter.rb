require 'googl'
require 'liquid'

module Feedbook
  module LiquidExtensions
    module Filters
      module GooglShortenerFilter

        # Shorten links with goo.gl
        # @param input [String] url
        # 
        # @return [String] url in shorten form
        def googl(input)
          url = Googl.shorten(input)
          url.short_url
        end
      end
    end
  end
end

Liquid::Template.register_filter(Feedbook::LiquidExtensions::Filters::GooglShortenerFilter)