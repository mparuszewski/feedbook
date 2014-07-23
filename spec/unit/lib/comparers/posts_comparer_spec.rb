require 'spec_helper'

describe Feedbook::Comparers::PostsComparer do

  describe '#get_new_posts' do
    let(:old_posts) { [OpenStruct.new(name: 'test1', url: 'test1.blog.lo'), OpenStruct.new(name: 'test1', url: 'test1.blog.lo'), OpenStruct.new(name: 'test3', url: 'test3.blog.lo'), OpenStruct.new(name: 'test1', url: 'test2.blog.lo')] }
    let(:new_posts) { old_posts + [OpenStruct.new(name: 'test1', url: 'test4.blog.lo'), OpenStruct.new(name: 'test1', url: 'test7.blog.lo'), OpenStruct.new(name: 'test6', url: 'test5.blog.lo'), OpenStruct.new(name: 'test7', url: 'test2.blog.lo')] }

    it 'should return only posts with urls that did not exists in old posts' do
      expect(Feedbook::Comparers::PostsComparer.get_new_posts(old_posts, new_posts)).to eq([OpenStruct.new(name: 'test1', url: 'test4.blog.lo'), OpenStruct.new(name: 'test1', url: 'test7.blog.lo'), OpenStruct.new(name: 'test6', url: 'test5.blog.lo')])
    end
  end
end
