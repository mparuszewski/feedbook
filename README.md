# Feedbook [![Build Status](https://travis-ci.org/pinoss/feedbook.svg?branch=master)](https://travis-ci.org/pinoss/feedbook) [![Code Climate](https://codeclimate.com/github/pinoss/feedbook.png)](https://codeclimate.com/github/pinoss/feedbook) [![Coverage Status](https://coveralls.io/repos/pinoss/feedbook/badge.png)](https://coveralls.io/r/pinoss/feedbook) 

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
    Loading notifiers... 
    Configuration loaded for TwitterNotifier
    Configuration loaded for FacebookNotifier
    completed.
    Fetching feeds for the first use... completed.
    Listener started...
    Fetching feeds...

And Feedbook now will work and listen for changes.

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
    consumer_key: SECRET_CONSUMER_KEY
    consumer_secret: SECRET_TWITTER_CONSUMER_SECRET
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

## Todo

Because Feedbook is still in development there is many to do:

* add Google+ Notifier
   Unfortunately Google+ does not provides API with ability to push messages to streams. Because of that I need to find a tool that will provide that feature without use of Google+.
* add links shortener (bit.ly or goo.gl) as a Liquid tag/filter
   Twitter limits Tweet length to 140 characters, why not to shorten links and rescue too long message.
* add ability to add own Notifier without forking Feedbook project
   I would like to give ability to users to create own Notifier plugins without any special development to Feedbook.
* add more tests
   I would like to add integration tests to make sure that all features work.

## Contributing

1. Fork it ( https://github.com/pinoss/feedbook/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
