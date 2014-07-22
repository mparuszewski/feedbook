require 'liquid'
require 'feedbook/factories/notifiers_factory'
require 'feedbook/errors/template_syntax_error'

module Feedbook
  class Notification
    
    attr_reader :type, :template, :variables

    def initialize(opts = {})
      @type      = opts.fetch(:type, '')
      @template  = opts.fetch(:template, '')
      @variables = opts.fetch(:variables, {})
    end

    def notify(object)
      compiled_template = Liquid::Template.parse(template)
      message = compiled_template.render(object.to_hash.merge(variables))
      
      notifier.notify(message)
    rescue SyntaxError => e
      raise Error::TemplateSyntaxError.new(e.message)
    end

    private

    def notifier
      @notifier ||= Factories::NotifiersFactory.create(type)
    end

  end
end
