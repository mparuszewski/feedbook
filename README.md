# Feedbook [![Build Status](https://travis-ci.org/pinoss/feedbook.svg?branch=master)](https://travis-ci.org/pinoss/feedbook) [![Code Climate](https://codeclimate.com/github/pinoss/feedbook.png)](https://codeclimate.com/github/pinoss/feedbook) [![Coverage Status](https://coveralls.io/repos/pinoss/feedbook/badge.png)](https://coveralls.io/r/pinoss/feedbook) [![Gem Version](https://badge.fury.io/rb/feedbook.svg)](http://badge.fury.io/rb/feedbook) 

Feedbook is a simple console application that allows to notify on IRC, mail and social media (like Twitter and Facebook) about RSS/Atom updates.
 
## Why?

> Automation isn’t about being lazy, it’s about being efficient. 
> ~ Addy Osmani

* If you do something every day, why not to automate it? 
* If you have a blog and want to notify your users on Twitter on Facebook that there is a new post, you can do it without opening your browser.

## Main Features

* Parse feeds and notifies about new posts.
* Easy to configure.
* Fire and forget - once you have valid configuration you do not need to think about feedbook again, everything will work automatically.

## Installation

Install gem with:

    $ gem install feedbook

## Usage

Install gem into your system:

    $ gem install feedbook

Create your configuration file or take a default file and modify it:

    $ feedbook init
    => Created default feedbook configuration file: feedbook.yml

After you create or modify your configuration file, you need to start listening for RSS changes: 

    $ feedbook start
    Loading configuration from file feedbook.yml... completed.
    Loading plugins from ./plugins... Plugins directory could not be found in ./plugins.
    Loading notifiers...
    Configuration loaded for FacebookNotifier
    Configuration loaded for TwitterNotifier
    completed.
    Fetching feeds for the first use... completed.
    Listener started...
    Fetching feeds...

And Feedbook now will work and listen for changes.

You can specify path for the config file with -c/--config flag:

    $ feedbook init -c my-feedbook-config.yml
    $ feedbook start -c my-feedbook-config.yml
    $ feedbook start offline -c my-feedbook-config.yml

### Offline mode

Now you can run feedbook with 'offline mode', which means that you can run feedbook with cron or run it manually. There is nothing more to configure, simply run feedbook with command:

    $ feedbook start offline
    Loading configuration from file feedbook.yml... completed.
    Loading plugins from ./plugins... Plugins directory could not be found in ./plugins.
    Loading notifiers...
    Configuration loaded for FacebookNotifier
    Configuration loaded for TwitterNotifier
    completed.
    Reading feeds from file... canceled. File does not exist.
    Fetching feeds for the first use... completed.
    Fetching feeds...
    No new posts found.
    Saving feeds to file... completed.

You can specify path for the archive file (-a/--archive flag):
    $ feedbook start offline --archive archive-feedbook.yml

## Configuration


```yaml
feeds:
  - url: https://github.com/pinoss.atom # collection of urls (separated by space)
    variables:                          # you can use variables defined here in your templates 
      default_header: Check out our new post
    notifications:                      # notifications configuration, you need to specify type and template for each notification
      - type: facebook
        template: "{{ default_header }} {{ title }} by {{ author }}: {{ url }}"
      - type: twitter
        template: "{{ default_header }} on our blog {{ feed_url }}: {{ title }}/{{ url }}"

configuration:
  interval: 5m
  facebook: # Facebook OAuth token
    token: SECRET_FACEBOOK_TOKEN
  twitter:  # Twitter token collection
    api_key: SECRET_API_KEY
    api_secret: SECRET_API_CONSUMER_SECRET
    access_token: SECRET_TWITTER_ACCESS_TOKEN
    access_token_secret: SECRET_TWITTER_ACCESS_TOKEN_SECRET
  irc:      # IRC configuration 
    url: irc.freenode.net
    port: 8001
    ssl_enabled: true/false
    channel: #channel
    nick: feedbook_bot
  mail:     # Mail configuration
    address: mparuszewski@feedbook.lo
    port: 5870
    domain: smtp.feedbook.lo
    username: mparuszewski
    password: your_password
    authentication: plain
    enable_starttls_auto: true/false
    
```

### Facebook

You need to generate your access token to use Facebook notifier, you can do that on [Graph API Explorer](https://developers.facebook.com/tools/explorer) page (click *Get access token* and select __user_status__).

### Twitter

You need to generate your keys here, you will need 4 keys, first two you will get on [Create an application](https://apps.twitter.com/app/new) page, after you create it, go to __API Keys__ tab and click __Create my access token__ at the bottom.

### Mail

Mail configuration is really simple, you need to specify few parameters and you will get mail notifications.

### IRC

IRC configuration is also very simple, I think it does not require any explanations.

## Templates

Feedbook uses Liquid for generating output. If you know Mustache it will not be a problem for you to write your template, it uses same syntax, but provides more features (like tags and helpers) - you can read about Liquid on [Liquid for Designers](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers).

## Plugins

Feedbook can use your custom plugins. You do not have to fork feedbook project and change source code if you want notify about RSS/Atom updates to custom Notifiers.
Currently you can have ability to use your own Notifiers and Liquid tags/filters.

By default plugins are being loaded from /plugins directory, you can set you own directory with -p/--plugins flag:

    $ feedbook start --plugins ./my_custom_plugins

### Notifiers

If you want to write your own Notifier you need to provide 2 methods: notify and load_configuration. Your Notifier should also include Singleton module.
In load_configuration method, given parameter opts gets hash with configuration from configuration file (under configuration node, you need to write name for your plugin as a node name and provide configuration under that node). Your Notifier class (in CamelCase) name should match name given in your configuration file (snake_case), ie. if you created MyCustomNotifier, notifier in configuration should be my_custom. 

```ruby
require 'singleton'

module Feedbook
  module Notifiers
    class YoutCustomNotifier
      include Singleton

      # Sends notification to Nil
      # @param message [String] message to be displayed in console
      #
      # @return [NilClass] nil
      def notify(message)
        puts "New message has been notified: #{message}"
      end

      # Load configuration for NullNotifier
      # @param configuration = {} [Hash] Configuration hash
      #
      # @return [NilClass] nil
      def load_configuration(opts = {})
        puts 'Configuration loaded for YourCustomNotifier'
      end
    end
  end
end
```

### Liquid extensions

You can also write custom Liquid extensions for your templates. You can even use extensions written for Jekyll. You can read more about extending Liquid on [Liquid for Programmers](https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers) page.

## Todo

Because Feedbook is still in development there is many to do:

* add Google+ Notifier
  * Unfortunately Google+ does not provides API with ability to push messages to streams. Because of that I need to find a tool that will provide that feature without use of Google+.
  * UPDATE: It is possible (with some limitations) through Google+ API (see [moments/insert](https://developers.google.com/+/api/latest/moments/insert)), but unfortunately there are no gems that support that feature.

## Contributing

1. Fork it ( https://github.com/pinoss/feedbook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
