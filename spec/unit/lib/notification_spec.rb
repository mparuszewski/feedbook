require 'spec_helper'

describe Feedbook::Notification do
  
  let(:hash) do
    {
      type:      'twitter',
      template:  'Post {{ test_variable }} on {{ url }}',
      variables: { 'test_variable' => 'test_value' }
    }
  end

  subject { Feedbook::Notification.new(hash) }
  
  describe '#initialize' do

    it 'parses hash and creates Notification instance' do
      expect(subject.type).to      eq('twitter')
      expect(subject.template).to  eq('Post {{ test_variable }} on {{ url }}')
      expect(subject.variables).to eq({ 'test_variable' => 'test_value' })
    end
  
    it 'should set default values' do
      expect(Feedbook::Notification.new({}).type).to      eq('')
      expect(Feedbook::Notification.new({}).template).to  eq('')
      expect(Feedbook::Notification.new({}).variables).to eq({})
    end
  end

  describe '#notify' do

    it 'create and send notification message to notifier' do
      expect(Liquid::Template).to receive_message_chain(parse: 'Post {{ test_variable }} on {{ url }}', render: { 'test_variable' => 'test_value', 'url' => 'test_url' })
      expect(subject).to          receive_message_chain(:notifier, notify: OpenStruct.new(to_hash: { 'url' => 'test_url' }))
      
      subject.notify(OpenStruct.new(to_hash: { 'url' => 'test_url' }))
    end

    it 'raises TemplateSyntaxError if template was not correct' do
      allow(Liquid::Template).to receive(:parse).with('Post {{ test_variable }} on {{ url }}').and_raise(SyntaxError)
      
      expect { subject.notify(OpenStruct.new(to_hash: { 'url' => 'test_url' })) }.to raise_error(Feedbook::Errors::TemplateSyntaxError)
    end
  end

end
