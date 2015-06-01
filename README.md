# G5 Authenticatable API

A set of helpers for securing Rails or Grape APIs using G5 Auth.

The helpers can be used in conjunction with
[devise_g5_authenticatable](https://github.com/G5/devise_g5_authenticatable)
to protect an API for a website, or they may be used to protect a stand-alone
service using token-based authentication.

## Current Version

0.4.0

## Requirements

* [rails](http://rubyonrails.org/) >= 3.2

**OR**

* [grape](https://github.com/intridea/grape)

## Installation

1. Add this line to your application's Gemfile:

   ```ruby
   gem 'g5_authenticatable_api'
   ```

2. And then execute:

   ```console
   bundle
   ```

## Configuration

### Auth endpoint

The API helpers need to know the endpoint for the G5 auth server to use when
validating tokens. This may be configured in one of several ways:

* Set the `G5_AUTH_ENDPOINT` environment variable (typically to either
   https://dev-auth.g5search.com or https://auth.g5search.com).

**OR**

* Configure the `G5AuthenticationClient` module directly, perhaps in an
  initializer:

  ```ruby
  G5AuthenticationClient.configure do |config|
    config.endpoint = 'https://dev-auth.g5search.com'
  end
  ```

### Strict token validation

If your API supports session-based authentication through
[devise_g5_authenticatable](https://github.com/G5/devise_g5_authenticatable),
then you have the option of toggling strict token validation.

If strict token validation is disabled (the default), then token validation
will be bypassed if there is already an authenticated user in warden. This
is fast, but it means that users with revoked or expired access tokens can
still access your API as long as the local session remains active.

```ruby
G5AuthenticatableApi.strict_token_validation = false
```

If strict token validation is enabled, then the session user's access token
will be periodically re-validated. Access to your API will be limited
to users with active access tokens, but there is a performance penalty
for this level of security.

```ruby
G5AuthenticatableApi.strict_token_validation = true
```

## Usage

### Rails

To require authentication for all API actions:

```ruby
class MyResourceController < ApplicationController
  before_filter :authenticate_api_user!

  respond_to :json

  # ...
end
```

To require authentication for some API actions:

```ruby
class MyResourceController < ApplicationController
  before_filter :authenticate_api_user!, only: [:create, :update]

  respond_to :json

  # ...
end
```

After authenticating an API user, you can retrieve the current token data as a
[`G5AuthenticationClient::TokenInfo`](https://github.com/G5/g5_authentication_client/blob/master/lib/g5_authentication_client/token_info.rb)
using the `token_data` helper:

```ruby
class MyResourceController < ApplicationController
  before_filter :authenticate_api_user!

  respond_to :json

  def index
    token_expiration = token_data.expires_in_seconds
    # ...
  end
end
```

You can retrieve the current user data using the `current_api_user` helper,
which will attempt to retrieve the data from
[warden](https://github.com/hassox/warden) if possible. Otherwise it will return
a [`G5AuthenticationClient::User`](https://github.com/G5/g5_authentication_client/blob/master/lib/g5_authentication_client/user.rb):

```ruby
class MyResourceController < ApplicationController
  before_filter :authenticate_api_user!

  respond_to :json

  def index
    user = current_api_user
    # ...
  end
end
```


Finally, you can retrieve the value of the access token in use for this request
by using the `access_token` helper:

```ruby
class MyResourceController < ApplicationController
  before_filter :authenticate_api_user!

  respond_to :json

  def index
    token = access_token
    # ...
  end
end
```

### Grape

To require authentication for all endpoints exposed by your API:

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::Helpers::Grape

  before { authenticate_user! }

  # ...
end
```

To selectively require authentication for some endpoints but not
others:

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::Helpers::Grape

  get :secure do
    authenticate_user!
    { secure: 'data' }
  end

  get :open do
    { hello: 'world' }
  end
end
```

After authenticating an API user, you can retrieve the current token data as a
[`G5AuthenticationClient::TokenInfo`](https://github.com/G5/g5_authentication_client/blob/master/lib/g5_authentication_client/token_info.rb)
using the `token_data` helper:

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::Helpers::Grape

  before { authenticate_user! }

  get :index do
    token_expiration = token_data.expires_in_seconds
    # ...
  end
end
```

You can retrieve the current user data using the `current_user` helper,
which will attempt to retrieve the data from
[warden](https://github.com/hassox/warden) if possible. Otherwise it will return
a [`G5AuthenticationClient::User`](https://github.com/G5/g5_authentication_client/blob/master/lib/g5_authentication_client/user.rb):

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::Helpers::Grape

  before { authenticate_user! }

  get :index do
    user = current_user
    # ...
  end
end
```

You can retrieve the value of the access token in use for this request with the
`access_token` helper:

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::Helpers::Grape

  before { authenticate_user! }

  get :index do
    token = access_token
    # ...
  end
end
```

### Submitting a token

Authenticated requests follow the requirements described by
[OAuth 2.0 Bearer Token specification](http://tools.ietf.org/html/rfc6750#section-2).
If you are relying on token-based authentication for your API, there are three
ways that an OAuth access token may be submitted as part of a request:

* In the `Authorization` HTTP header, with the format "Bearer \<access_token\>"

  ```http
  GET /resource HTTP/1.1
  Host: server.example.com
  Authorization: Bearer mF_9.B5f-4.1JqM
  ```

* As the value of the `access_token` form-encoded body parameter:

  ```http
  POST /resource HTTP/1.1
  Host: server.example.com
  Content-Type: application/x-www-form-urlencoded

  access_token=mF_9.B5f-4.1JqM
  ```

* As the value of the `access_token` query URI parameter:

  ```http
  GET /resource?access_token=mF_9.B5f-4.1JqM HTTP/1.1
  Host: server.example.com
  ```

### Unauthorized response

If there is no logged in user and token authentication fails, secure API methods
will return a response with an HTTP status of 401. More detailed information will
be available in the `WWW-Authenticate` response header, as described in the
[OAuth 2.0 Bearer Token specification](http://tools.ietf.org/html/rfc6750#section-3).

In brief, `WWW-Authenticate` header will contain one of the following error codes
when token validation fails against G5 Auth:

* `invalid_request` (the default)
* `invalid_token`
* `insufficent_scope`

The header may also have an error description if one is available. For
example:

```http
HTTP/1.1 401 Unauthorized
     WWW-Authenticate: Bearer realm="example",
                       error="invalid_token",
                       error_description="The access token expired"
```

## Examples

### Securing an Ember application backed by a Grape API

Use devise to protect the controller action that serves your ember
application:

```ruby
class WelcomeController < ApplicationController
  before_filter :authenticate_user!

  def index
  end
end
```

Then protect the API that ember talks to:

```ruby
class MyApi < Grape::API
  helpers G5AuthenticatableApi::Helpers::Grape

  before { authenticate_user! }

  # Your API endpoints ...
end
```

That's it! No client-side changes are necessary.

### Token-based authentication for a Rails API

Protect your API actions in your controller:

```ruby
class Api::MyResourcesController < ApplicationController
  before_filter :authenticate_api_user!

  respond_to :json

  def show
    # ...
  end
end
```

To include the token in the authorization header:

```console
curl --header "Authorization: Bearer this-is-where-my-token-goes" https://myhost/api/my_resources/42
```

To include the token as a param:

```console
curl https://myhost/api/my_resources/42?access_token=this-is-where-my-token-goes
```

## Authors

* Maeve Revels / [@maeve](https://github.com/maeve)
* Rob Revels / [@sleverbor](https://github.com/sleverbor)

## Contributing

1. [Fork it](https://github.com/G5/g5_authenticatable_api/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your code and **specs**
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/G5/g5_authenticatable_api/issues).

### Specs

Before running the specs for the first time, you will need to initialize the
database for the test Rails application.

```console
$ cp spec/dummy/config/database.yml.sample spec/dummy/config/database.yml
$ (cd spec/dummy; RAILS_ENV=test bundle exec rake db:setup)
```

To execute the entire test suite:

```console
$ bundle exec rspec spec
```

## License

Copyright (c) 2014 G5

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

