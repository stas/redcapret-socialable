require 'spec_helper'

describe 'Redcarpet::Socialable::(Mentions + Hashtags)' do
  let(:document) { '@mention and #tagged' }
  let(:render_class) { Redcarpet::Render::HTML }
  let(:markdown) do
    Redcarpet::Markdown.new(render_class)
  end

  subject { markdown.render(document) }

  describe 'class using both' do
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Mentions
        include Redcarpet::Socialable::Hashtags
      end
    end

    it { should include(render_class.new.send(:mention_template, 'mention'))}
    it { should include(render_class.new.send(:hashtag_template, 'tagged'))}
  end
end
