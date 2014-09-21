require 'spec_helper'

describe Feedbook::Notification do

  let(:hash) do
    {
      type:             'twitter',
      template:         'Post {{ test_variable }} on {{ url }}',
      update_template:  'Updated post {{ test_variable }} on {{ url }}',
      variables:        { 'test_variable' => 'test_value' }
    }
  end

  subject { Feedbook::Notification.new(hash) }

  describe '#initialize' do

    it 'parses hash and creates Notification instance' do
      expect(subject.type).to      eq('twitter')
      expect(subject.variables).to eq({ 'test_variable' => 'test_value' })
    end

    it 'should set default values' do
      expect(Feedbook::Notification.new({}).type).to      eq('')
      expect(Feedbook::Notification.new({}).variables).to eq({})
    end
  end

  describe '#notify' do

    let(:template) { double }

    it 'create and send notification message to notifier' do
      allow(template).to          receive(:render)
      allow(Liquid::Template).to  receive(:parse).and_return(template)
      expect(Liquid::Template).to receive(:parse).with('Post {{ test_variable }} on {{ url }}')
      expect(Liquid::Template).to receive(:parse).with('Updated post {{ test_variable }} on {{ url }}')
      expect(template).to receive(:render).with({ 'test_variable' => 'test_value', 'url' => 'test_url' })

      expect(subject).to          receive_message_chain(:notifier, notify: OpenStruct.new(to_hash: { 'url' => 'test_url' }))

      subject.notify(OpenStruct.new(to_hash: { 'url' => 'test_url' }))
    end

    it 'raises TemplateSyntaxError if template was not correct' do
      allow(Liquid::Template).to receive(:parse).with('Post {{ test_variable }} on {{ url }}').and_raise(SyntaxError)

      expect { subject.notify(OpenStruct.new(to_hash: { 'url' => 'test_url' })) }.to raise_error(Feedbook::Errors::TemplateSyntaxError)
    end
  end

end
