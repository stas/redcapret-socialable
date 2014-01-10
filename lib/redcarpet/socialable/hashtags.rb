require 'redcarpet'

module Redcarpet::Socialable::Hashtags

  def postprocess(document)
    # Disable postprocess-ing for legacy renderer
    unless respond_to?(:safe_replace)
      document = process_hashtags(document)
    end

    if defined?(super)
      super(document)
    else
      document
    end
  end

  private

  def hashtag_template(text)
    # Some backwards compatibility
    if respond_to?(:tag_template)
      tag_template(text)
    else
      %(<a href="#" title="#{text}">##{text}</a>)
    end
  end

  def hashtag_regexp
    '#([\w\-]+)'
  end

  def hashtag?(matched_text)
    # Some backwards compatibility
    if respond_to?(:highlight_tag?)
      matched_text if highlight_tag?(matched_text)
    else
      matched_text
    end
  end

  def process_hashtags(text)
    # Find and render tags
    regexp = Regexp.new(::Redcarpet::Socialable::BASE_REGEXP % hashtag_regexp)

    text.gsub!(regexp) do |match|
      start_tag, before, raw, after, close_tag = $1, $2, $3, $4, $5
      return match if start_tag.to_s.start_with?('<a')

      if hashtag = hashtag?(raw)
        %{#{start_tag}#{before}#{hashtag_template(hashtag)}#{after}#{close_tag}}
      else
        match
      end
    end

    text
  end

end
