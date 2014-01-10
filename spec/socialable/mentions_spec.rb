require 'spec_helper'

describe Redcarpet::Socialable::Mentions do
  let(:document) { '@mention' }
  let(:render_class) { Redcarpet::Render::HTML }
  let(:markdown) do
    Redcarpet::Markdown.new(render_class)
  end

  subject { markdown.render(document) }

  describe '#postprocess' do
    context 'wont work for legacy version which include #safe_replace' do
      let(:render_class) do
        Class.new(Redcarpet::Render::HTML) do
          include Redcarpet::Socialable::Mentions

          def safe_replace ; end
        end
      end

      it { should eq("<p>%s</p>\n" % document) }
    end

    context 'renders mentions' do
      let(:render_class) do
        Class.new(Redcarpet::Render::HTML) do
          include Redcarpet::Socialable::Mentions
        end
      end

      before do
        %w{mention_template mention? mention_regexp process_mentions}.each do
          |met| markdown.renderer.should_receive(met).and_call_original
        end
      end

      it { should include(render_class.new.send(:mention_template, 'mention'))}
    end
  end

  describe '#mention_template' do
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Mentions

        def mention_template(t) '{{{%s}}}' % t; end
      end
    end

    it { should include('{{{mention}}}')}
  end

  describe '#mention_regexp' do
    let(:document) { '+plus' }
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Mentions

        def mention_regexp; '\+([\w-]+)'; end
      end
    end

    it { should include(render_class.new.send(:mention_template, 'plus'))}
  end

  describe '#mention?' do
    let(:render_class) do
      Class.new(Redcarpet::Render::HTML) do
        include Redcarpet::Socialable::Mentions

        def mention?(t) false; end
      end
    end

    it { should eq("<p>@mention</p>\n")}

    context 'returns a processed string' do
      let(:mention) { 'MENTION' }
      before { markdown.renderer.should_receive(:mention?).and_return(mention) }

      it { should include(render_class.new.send(:mention_template, mention))}
    end
  end

end
