# @mention and #hashtag for Markdown

This gem provides a HTML renderer for [redcarpet](https://github.com/vmg/redcarpet).

## How to use

```ruby
gem "redcarpet-socialable", github: "releu/redcapret-socialable"
```

```ruby
# override the following methods for your case
class MyAwesomeRenderer < Redcarpet::Socialable
  def highlight_tag?(name)
    Tag.where(name: name.downcase).first_or_create!
  end

  def highlight_username?(name)
    User.where(username: name).exists?
  end

  def tag_template(name)
    %(<a>##{name}</a>)
  end

  def mention_template(name)
    %(<a>@#{name}</a>)
  end
end

# use redcarpet's options https://github.com/vmg/redcarpet
renderer = MyAwesomeRenderer.new
# space_after_headers must be true for hashtag feature
markdown = Redcarpet::Markdown.new(renderer, space_after_headers: true)

markdown.render "#foo\n@bar" # => <p><a>#foo</a><br><a>@bar</a></p>
```

### Mixins

There are two modules you can use as mixins to extend an existing renderer
with features from `Redcarpet::Socialable`: `Mentions` and `Hashtags`.

These mixins will hook into renderer `#postprocessing` method in order
to process mentions or hashtags.

Here's a basic example for mentions:

```ruby
class MentionsRenderer < Redcarpet::Render::HTML
  include Redcarpet::Socialable::Mentions
end
```

`Redcarpet::Socialable::Mentions` mentions you can overwrite include:

* `#mention_template`
* `#mention?` - works as `#highlight_username?` from `Redcarpet::Socialable`
* `#mention_regexp` - Use it to change the regexp to match a mention

And a basic example for hashtags:

```ruby
class HashtagsRenderer < Redcarpet::Render::HTML
  include Redcarpet::Socialable::Hashtags
end
```

`Redcarpet::Socialable::Hashtags` mentions you can overwrite include:

* `#hashtag_template` - works as `#tag_template` from `Redcarpet::Socialable`
* `#hashtag?` - works as `#highlight_tag?` from `Redcarpet::Socialable`
* `#hashtag_regexp` - Use it to change the regexp to match a hashtag
