require 'redcarpet'

module Redcarpet::Socialable::Mentions

  def postprocess(document)
    # Disable postprocess-ing for legacy renderer
    return document if respond_to?(:safe_replace)

    document = process_mentions(document)

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
      highlight_username?(matched_text)
    else
      true
    end
  end

  def process_mentions(text)
    regexp = Regexp.new(::Redcarpet::Socialable::BASE_REGEXP % mention_regexp)

    text.gsub!(regexp) do |match|
      before, raw, after = $1, $2, $3
      if mention?(raw)
        before + mention_template(raw) + after
      else
        match
      end
    end

    text
  end
end
