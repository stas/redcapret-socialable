require 'spec_helper'

describe Redcarpet::Socialable::Hashtags do
  let(:document) { ' #tagged' }
  let(:render_class) { Redcarpet::Render::HTML }
  let(:markdown) do
    Redcarpet::Markdown.new(render_class)
  end

  subject { markdown.render(document) }

  describe '#postprocess' do
    context 'wont work for legacy version which include #safe_replace' do
      let(:render_class) do
        Class.new(Redcarpet::Render::HTML) do
          include Redcarpet::Socialable::Hashtags

          def safe_replace ; end
        end
      end

      it { should eq("<p>%s</p>\n" % document.strip) }
    end

    context 'renders hashtags' do
      let(:render_class) do
        Class.new(Redcarpet::Render::HTML) do
          include Redcarpet::Socialable::Hashtags
        end
      end

      before do
        %w{hashtag_template hashtag? hashtag_regexp process_hashtags}.each do
          |met| markdown.renderer.should_receive(met).and_call_original
        end
      end

      it { should include(render_class.new.send(:hashtag_template, 'tagged'))}
    end
  end

  describe '#hashtag_template' do
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Hashtags

        def hashtag_template(t) '{{{%s}}}' % t; end
      end
    end

    it { should include('{{{tagged}}}')}
  end

  describe '#hashtag_regexp' do
    let(:document) { '+plustag' }
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Hashtags

        def hashtag_regexp; '\+([\w-]+)'; end
      end
    end

    it { should include(render_class.new.send(:hashtag_template, 'plustag'))}
  end

  describe '#hashtag?' do
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Hashtags

        def hashtag?(t) false; end
      end
    end

    it { should eq("<p>#tagged</p>\n")}
  end

end
