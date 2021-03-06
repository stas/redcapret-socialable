require 'redcarpet'

module Redcarpet::Socialable::Mentions

  def postprocess(document)
    # Disable postprocess-ing for legacy renderer
    unless respond_to?(:safe_replace)
      document = process_mentions(document)
    end

    if defined?(super)
      super(document)
    else
      document
    end
  end

  private

  # Template to be used to render mentions
  def mention_template(text)
    %(<a href="#" title="#{text}">#{text}</a>)
  end

  def mention_regexp
    '@([\w-]+)'
  end

  def mention?(matched_text)
    # Some backwards compatibility
    if respond_to?(:highlight_username?)
      matched_text if highlight_username?(matched_text)
    else
      matched_text
    end
  end

  def process_mentions(text)
    regexp = Regexp.new(::Redcarpet::Socialable::BASE_REGEXP % mention_regexp)

    text.gsub!(regexp) do |match|
      start_tag, before, raw, after, close_tag = $1, $2, $3, $4, $5
      return match if start_tag.to_s.start_with?('<a')

      if mention = mention?(raw)
        %{#{start_tag}#{before}#{mention_template(mention)}#{after}#{close_tag}}
      else
        match
      end
    end

    text
  end
end
