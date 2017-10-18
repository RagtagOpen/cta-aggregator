RSpec.shared_examples 'share_url examples' do |subject|

  it "expects properly formatted share_urls" do
    subject.share_url = 'foo'
    expect(subject.valid?).to be false
    subject.share_url = 'www.facebook.com/bleh'
    expect(subject.valid?).to be false
    subject.share_url = 'http://www.facebook.com/bleh'
    expect(subject.valid?).to be true
    subject.share_url = 'https://www.facebook.com/bleh'
    expect(subject.valid?).to be true
    subject.share_url = 'https://facebook.com/bleh'
    expect(subject.valid?).to be true
    subject.share_url = 'https://facebook.com/bleh?ping=pong'
    expect(subject.valid?).to be true
  end

end
