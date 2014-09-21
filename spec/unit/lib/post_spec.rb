require 'spec_helper'

describe Feedbook::Post do

  let(:hash) do
    {
      author:     'mparuszewski',
      published:  Time.new(2014, 7, 23, 21, 0, 0),
      url:        'http://blog.test.lo/post',
      title:      'Test Post',
      feed_title: 'Blog Title',
      message_id: '123'
    }
  end

  subject { Feedbook::Post.new(hash) } 

  describe '#initialize' do

    it 'parses hash and creates Post instance' do
      expect(subject.author).to     eq('mparuszewski')
      expect(subject.published).to  eq(Time.new(2014, 7, 23, 21, 0, 0))
      expect(subject.url).to        eq('http://blog.test.lo/post')
      expect(subject.title).to      eq('Test Post')
      expect(subject.feed_title).to eq('Blog Title')
      expect(subject.message_id).to eq('123')
    end

    it 'should raise KeyError if one of parameter is missing' do
      expect { Feedbook::Post.new({}) }.to raise_error(KeyError)
    end
  end

  describe '#to_hash / #to_h' do

    let(:expected_hash) do
      {
        'author'     => 'mparuszewski',
        'published'  => Time.new(2014, 7, 23, 21, 0, 0),
        'url'        => 'http://blog.test.lo/post',
        'title'      => 'Test Post',
        'feed_title' => 'Blog Title',
        'message_id' => '123'
      }
    end

    it 'should return hash with Post parameters' do
      expect(subject.to_hash).to eq(expected_hash)
      expect(subject.to_h).to    eq(expected_hash)
    end
  end
end
