require "spec_helper"

RSpec.describe S3find do
  it "has a version number" do
    expect(S3find::VERSION).not_to be nil
  end
end

RSpec.describe S3find::Item do
  let(:size)      { 10 } 
  let(:modified)  { '2017-01-01T10:11:12Z000' }
  subject         { described_class.new(key: 'filename', size: size, modified: modified) }
  
  it "initializes" do
    expect(subject).to be_a(described_class)
    expect(subject.size).to eq(size.to_i)
    expect(subject.modified).to eq(Time.parse(modified))
  end
end

RSpec.describe S3find::Base do
  subject { described_class.new('spec/test_data.xml') }

  it "instantiates" do
    expect(subject).to be_instance_of(described_class)
    expect(subject.items.count).to eq(285)
  end

  it "finds all files" do
    expect(subject.find.count).to eq(285)
  end
 
  it "filters by name" do
    text = 'UK' 
    subject.find(name: text).each{|e| expect(e.key).to include(text)}
  end

  it "filters by case insenitive name" do
    text = 'uk' 
    subject.find(iname: text).each{|e| expect(e.key.downcase).to include(text.downcase)}
  end

  it "sorts" do
    %w(key size modified).each do |field|
      result = subject.find(sort: field)
      expect(result.first.send(field)).to be <= result.second.send(field)
    end
  end

  it "reverse sorts" do
    %w(key size modified).each do |field|
      result = subject.find(sort: field, reverse: true)
      expect(result.first.send(field)).to be >= result.second.send(field)
    end
  end 

  it "limits" do
    expect(subject.find(limit: 10).count).to eq(10)
  end
end

RSpec.describe S3find::Application do
  subject         { described_class.new }
  
  it "initializes" do
    expect(subject).to be_a(described_class)
  end
end
