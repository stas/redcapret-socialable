# @mention and #hashtag for Markdown

This gem provides a HTML renderer for [redcarpet](https://github.com/vmg/redcarpet).

## How to use

```ruby
gem "tweetable-redcarpet"
```

```ruby
# override methods for your case
class MyAwesomeRenderer < TweetableRedcarpet
  def highlight_tag?(name)
    true # User.where(username: name).exists?
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
end
```
