require "redcarpet"

module Redcarpet
  class Socialable < Redcarpet::Render::HTML
    autoload :Mentions, 'redcarpet/socialable/mentions'
    autoload :Hashtags, 'redcarpet/socialable/hashtags'

    include Mentions
    include Hashtags

    BASE_REGEXP =
      # If there's an HTML tag, catch it, we need this to exclude link tags
      '(<\/?[^>]*>)?' +
      # There should be a whitespace or beginning of line
      '(^|[\s\>])+' +
      # Placeholder for what we want to match
      '%s' +
      # This is where match ends
      '(\b|\-|\.|,|:|;|\?|!|\(|\)|$)' +
      # Closing HTML tag if any
      '(<\/?[^>]*>)?'

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
