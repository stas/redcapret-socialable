require 'redcarpet'

module Redcarpet::Socialable::Hashtags

  def postprocess(document)
    if self.respond_to?(:process_hashtags?) and process_hashtags?
      document = process_hashtags(text)
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
    self.respond_to?(:highlight_tag?) ? highlight_tag?(matched_text) : true
  end

  def process_hashtags(text)
    html_extractions = {}
    extraction_template = '{extraction-%s}'

    # Cut HTML tags first, to avoid messing up those
    text.gsub!(%r{>.*?</}m) do |match|
      md5 = Digest::MD5.hexdigest(match)
      html_extractions[md5] = match
      extraction_template % md5
    end

    # highlight tags
    regexp = Regexp.new(::Redcarpet::Socialable::BASE_REGEXP % hashtag_regexp)
    text.gsub!(regexp) do |match|
      before, raw, after = $1, $2, $3
      if hashtag?(raw)
        before + hashtag_template(raw) + after
      else
        match
      end
    end

    # Paste back previously extracted HTML tags
    html_extractions.each do |md5, html|
      extraction = extraction_template % md5
      text.sub!(extraction, html)
    end

    text
  end

end
