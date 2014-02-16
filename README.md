# G5 Authenticatable API

A set of helpers for securing Rack-based APIs using G5 Auth.

The helpers can be used in conjunction with [warden](https://github.com/hassox/warden)
(and therefore, [devise](https://github.com/plataformatec/devise)) to protect
an API for a website (e.g. an [ember](http://emberjs.com) application). Or
they may be used to protect a stand-alone service using token-based authentication
as described by the [OAuth 2.0 Bearer Token](http://tools.ietf.org/html/rfc6750)
specification.

## Current Version

0.0.1 (unreleased)

## Requirements

* rack

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

TODO

## Usage

TODO

## Examples

TODO

## Authors

* Maeve Revels / [@maeve](https://github.com/maeve)
* Rob Revels / [@sleverbor](https://github.com/sleverbor)

## Contributing

1. [Fork it](https://github.com/g5search/g5_authenticatable_api/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write your code and **specs**
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

If you find bugs, have feature requests or questions, please
[file an issue](https://github.com/g5search/g5_authenticatable_api/issues).

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

