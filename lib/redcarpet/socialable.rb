require "redcarpet"

module Redcarpet
  class Socialable < Redcarpet::Render::HTML
    autoload :Mentions, 'redcarpet/socialable/mentions'
    autoload :Hashtags, 'redcarpet/socialable/hashtags'

    include Mentions
    include Hashtags

    BASE_REGEXP = '(^|[\s\>])+%s(\b|\-|\.|,|:|;|\?|!|\(|\)|$){1}'

    def paragraph(text)
      "<p>#{safe_replace(text)}</p>"
    end

    def list_item(text, list_type)
      "<li>#{safe_replace(text)}</li>"
    end

    def header(text, level)
      "<h#{level}>#{safe_replace(text)}</h#{level}>"
    end

    def safe_replace(text)
      text = process_mentions(text)
      process_hashtags(text)
    end
  end
end
