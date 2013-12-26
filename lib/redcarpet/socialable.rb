require "redcarpet"

module Redcarpet
  class Socialable < Redcarpet::Render::HTML
    BASE_REGEXP = '(^|[\s])+%s(\b|\-|\.|,|:|;|\?|!|\(|\)|$){1}'
  
    def paragraph(text)
      "<p>#{safe_replace(text)}</p>"
    end
  
    def list_item(text, list_type)
      "<li>#{safe_replace(text)}</li>"
    end
  
    def header(text, level)
      "<h#{level}>#{safe_replace(text)}</h#{level}>"
    end
  
    private
    def highlight_tag?(name)
      true
    end
  
    def highlight_username?(name)
      true
    end
  
    def tag_template(name)
      %(<a href="#" title="#{name}">##{name}</a>)
    end
  
    def mention_template(name)
      %(<a href="#" title="#{name}">@#{name}</a>)
    end
  
    def safe_replace(text)
      replaces = {}
    
      # cut all tags
      text.gsub!(%r{>.*?</}m) do |match|
        md5 = Digest::MD5.hexdigest(match)
        replaces[md5] = match
        "{extraction-#{md5}}"
      end
    
      # highlight tags
      regexp = Regexp.new(BASE_REGEXP % '#([\w\-]+)')
      text.gsub!(regexp) do |match|
        before, raw, after = $1, $2, $3
        if highlight_tag?(raw)
          %(#{before}#{tag_template(raw)}#{after})
        else
          match
        end
      end
    
      # highlight users
      regexp = Regexp.new(BASE_REGEXP % '@([\w-]+)')
      text.gsub!(regexp) do |match|
        before, raw, after = $1, $2, $3
        if highlight_username?(raw)
          %(#{$1}#{mention_template(raw)}#{$3})
        else
          match
        end
      end
    
      # paste all tags
      text.gsub!(/\{extraction-([0-9a-f]{32})\}/) do
        replaces[$1]
      end
    
      text
    end
  end
end
