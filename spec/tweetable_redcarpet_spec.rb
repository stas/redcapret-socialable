require File.expand_path("../../lib/tweetable_redcarpet", __FILE__)

class NoTags < TweetableRedcarpet
  def highlight_tag?(name)
    false
  end
end

class NoMentions < TweetableRedcarpet
  def highlight_username?(name)
    false
  end
end

class SpanTags < TweetableRedcarpet
  def tag_template(name)
    "<span>#{name}</span>"
  end
end

class SpanMentions < TweetableRedcarpet
  def mention_template(name)
    "<span>#{name}</span>"
  end
end

describe TweetableRedcarpet do
  let(:renderer) { TweetableRedcarpet.new }
  let(:markdown) do
    Redcarpet::Markdown.new(renderer, space_after_headers: true)
  end
  
  it "returns html" do
    sample = "foo\n\nbar"
    expect(markdown.render(sample)).to match(/</)
  end
  
  { "@mentions" => "@", "#hashtags" => "#" }.each do |type, char|
    context "highlighting #{type}" do
      subject { markdown.render(sample) }
    
      context "in paragraphs" do
        let(:sample) { "#{char}bar" }
        
        it { expect(subject).to match(/<a/) }
      end
    
      context "in lists" do
        let(:sample) { "* foo\n* #{char}bar\n* buz" }
        
        it { expect(subject).to match(/<a/) }
      end
      
      context "in blockquote" do
        let(:sample) { "> foo #{char}bar buz" }
        
        it { expect(subject).to match(/<a/) }
      end
      
      context "in headers" do
        let(:sample) { "# foo #{char}bar buz" }
        
        it { expect(subject).to match(/<a/) }
      end
    end
  end
  
  describe "override #highlight_tag?" do
    let(:renderer) { NoTags.new }
    let(:sample) { "#foo" }
    subject { markdown.render(sample) }
    
    it { expect(subject).not_to match(/<a/) }
  end
  
  describe "override #highlight_mention?" do
    let(:renderer) { NoMentions.new }
    let(:sample) { "@foo" }
    subject { markdown.render(sample) }
    
    it { expect(subject).not_to match(/<a/) }
  end
  
  describe "override #tag_template?" do
    let(:renderer) { SpanTags.new }
    let(:sample) { "#foo" }
    subject { markdown.render(sample) }
    
    it { expect(subject).to match(/<span/) }
  end
  
  describe "override #mention_template" do
    let(:renderer) { SpanMentions.new }
    let(:sample) { "@foo" }
    subject { markdown.render(sample) }
    
    it { expect(subject).to match(/<span/) }
  end
end
