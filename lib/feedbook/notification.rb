require 'liquid'
require 'feedbook/liquid_extensions'
require 'feedbook/factories/notifiers_factory'
require 'feedbook/errors/template_syntax_error'
require 'feedbook/errors/invalid_variables_format_error'

module Feedbook
  class Notification
    attr_reader :type, :template, :variables

    # Initializes Notification instance
    # @param opts = {} [Hash] Hash with 
    #
    # @return [type] [description]
    def initialize(opts = {})
      @type      = opts.fetch(:type, '')
      @variables = opts.fetch(:variables, {})
      @template  = parse_template(opts.fetch(:template, ''))
    end

    # Notifies selected gateway about new post
    # @param object [Object] objct that respond to :to_hash method
    #
    # @return [NilClass] nil
    def notify(object)
      message = template.render(object.to_hash.merge(variables))

      message_id = notifier.notify(message)
      object.message_id = message_id

      object
    end

    # Validates if given parameters are valid
    #
    # @return [NilClass] nil
    # @raise [Feedbook::Errors::InvalidVariablesFormatError] if variables parameter is not a Hash
    def valid?
      unless variables.is_a? Hash
        raise Errors::InvalidVariablesFormatError.new
      end
    end

    private

    # Parses template from string into a valid Liquid::Template
    # @param template [String] String with valid Liquid template
    #
    # @return [Liquid::Template] compiled Liquid template
    # @raise [Feedbook::Errors::TemplateSyntaxError] if there is a SyntaxError inside template
    def parse_template(template)
      Liquid::Template.parse(template)
    rescue SyntaxError => e
      raise Errors::TemplateSyntaxError.new(e.message)
    end

    # Returms Notifier instance
    #
    # @return [Notifier] Notifier instance for given type
    def notifier
      @notifier ||= Factories::NotifiersFactory.create(type)
    end
  end
end
