# AccessContext

A flexible and efficient context based permission management library for Ruby applications.

## Installation

```ruby
$ bundle add access_context
```

## Usage

1. Setup roles and permission with context

```ruby
AccessContext.config do

  roles do
    grant :admin, ['default', 'order_read', 'admin_default']
    grant :support, 'default'
    grant :support, 'order_read'
  end

  permissions do
    grant 'default' do
      controller :home, [:show]
      controller :dashboard, [:show]
      service :visit, :call
      job :welcome, :perform
    end
    grant 'admin_default' do
      controller "admin/products"
      controller 'admin/dashboard', [:show]
      context :controller, "admin/orders", :show
    end
    grant 'order_read' do
      controller :orders, [:show]
      view 'admin/orders', ["order_edit_button"]
    end
  end

end
```

2. Check access by role on each context

```ruby
AccessContext.controller(:home, :show).permit_role?(:admin) #=> true
AccessContext.service(:visit, :call).permit_role?(:support) #=> true
AccessContext.job(:welcome, :perform).permit_role?(:admin) #=> true
AccessContext.view("admin/orders", :order_edit_button).permit_role?(:support) #=> false
```

Or we can use `permit?` if we have `role` column/attribute on `User`.

```ruby
admin = User.new(role: :admin)
AccessContext.controller(:home, :show).permit?(admin) #=> true
AccessContext.job(:welcome, :perform).permit?(admin) #=> true

support = User.new(role: :support)
AccessContext.service(:visit, :call).permit?(support) #=> true
AccessContext.view("admin/orders", :order_edit_button).permit?(support) #=> false
```

3. Integrate it with Rails 

```ruby
# Controller
class ApplicationController < ActionController::Base
  before_action :verify_permission

  private

  def verify_permission
    return unless current_user

    controller_name = self.class.name.underscore.sub(/_controller$/, '')
    context = AccessContext.new(controller_name, action_name)
    head :forbidden unless context.permit?(current_user)
  end
end

# View: app/views/home/index.html.erb
<%= context = AccessContext.view(:home, :login_button) %>

<%= if context.permit?(current_user) %>
    <button>Login</button>
<% end %>

# Job: app/jobs/notify_job.rb
class NotifyJob < ApplicationJob

    def perform(user_id)
        user = User.find(user_id)
        context = AccessContext.job(:notify_job, :perform)
        if context.permit?(user)
            # ...
        end
    end

end

# Service app/services/order_service.rb
class OrderService
    def initialize(user)
        @user = user
    end

    def test_a
        if AccessContext.service(:order, :test_a).permit?(@user)
            # ...
        end
    end

    def test_b
        if AccessContext.service(:order, :test_b).permit?(@user)
            # ...
        end
    end
end
```

## Development

```ruby
bundle install
meval bundle install
meval rake

# Test with a specific Ruby version
meval -r 3.1 bundle install
meval -r 3.1 rake

# Or test for all support Ruby version
meavl -a bundle install
meavl -a rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hoppergee/access_context. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hoppergee/access_context/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AccessContext project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hoppergee/access_context/blob/main/CODE_OF_CONDUCT.md).
