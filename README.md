[![Gem Version](https://badge.fury.io/rb/strong-permitter.svg)](https://badge.fury.io/rb/strong-permitter)

# StrongPermitter

This gem allows move params permissions from controllers to separated permission-objects. Used strong parameters whitelists.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strong-permitter'
```

And then execute:

    $ bundle

## Usage

Before you start using permission-objects, you need integrate StrongPermitter::Manager to your controllers.
For this, you may execute console command, which create file strong_permitter.rb in initializers directory:

    $ strong_permitter install

Or you may include StrongPermitter::Manager into ApplicationController:

```ruby
class ApplicationController < ActionController::Base
    include StrongPermitter::Manager
end
```

For define permission-object you should create ruby file in `app/controllers/permissions` directory.
File name should match with controller. For `ArticlesController` permission-object file name should be `articles_permission.rb`.

Permission-object code:

```ruby
class ArticlesPermission < StrongPermitter::Permission::Base

    # standard actions permission
    create_params :title, :content, :author_name
    update_params :content

    # for non-standard actions permissions use:
    # allowed_params_for :action_name, :param1, :param2, ...
    allowed_params_for :activate_article, :activation_status
    
    # also, you can set default resource name for this permission object (by default used controller name):
    # self.resource_name = :blog
end
```

If you need use different resource names for different actions, you may set optional last argument `:resource` in `create_params`, `update_params` or `allowed_params_for` methods, like this:

```Ruby
class ArticlesPermission < StrongPermitter::Permission::Base
    create_params :title, :description, :author_name, resource: :blog
    update_params :title, :text, :blog_id, resource: :blog_post
end
```


After that, you may use `permitted_params` method for your action methods:

```ruby
class ArticlesController < ApplicationController
    def update
        @article = Article.find(params[:id])
        if @article.update_attributes(permitted_params)
            # ...
        else
            # ...
        end
    end

    def create
        @article = Article.new(permitted_params)
        if @article.save
            # ...
        else
            # ...
        end
    end

    # non-standard action
    def activate_article
        @article = Article.find(params[:id])
        @article.update_attributes(permitted_params)
        # ...
    end
end
```

## Contributing

1. Fork it ( https://github.com/evg2108/strong-permitter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
