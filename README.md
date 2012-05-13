restafari
=========

A ruby DSL for consuming RESTful APIs


usage
========

```ruby
  @require "restafari"
  class MyClass
    @include Restafari::Action

    action :sign_in, "/path", {
      default: "value"
    }
  end
```

You can also hook into the request and add your own filters(i.e for signing and other global params)

```ruby
  Restafari.config.before_request do |params|
    params[:test] = true
  end
```

this will add the "test" parameter to each request.