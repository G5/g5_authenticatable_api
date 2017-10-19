## v1.0.0 (2017-10-19)

* **Backwards incompatible changes**
  * Drop support for ruby < 2.2
  * Drop support for rails < 4.1
* Enhancements
  * Add support for ruby 2.3 and 2.4
  * Add support for rails 5.0 and 5.1

## v0.4.0 (2015-05-22)

* Add helpers for retrieving current API user as well as more detailed token
  information
  ([#8](https://github.com/G5/g5_authenticatable_api/pull/8))

## v0.3.2 (2015-04-20)

* Fix for case-insensitive authorization request header
  ([#7](https://github.com/G5/g5_authenticatable_api/pull/7))

## v0.3.1 (2015-01-20)

* Disable strict token validation for session-authenticated users by
  default; enable with `G5AuthenticatableApi.strict_token_validation = true`
  ([#6](https://github.com/G5/g5_authenticatable_api/pull/6)).

## v0.3.0 (2014-12-23)

* When there is already an authenticated session, validate the current
  user's access token against the auth server on every API request
  ([#5](https://github.com/G5/g5_authenticatable_api/pull/5))

## v0.2.0 (2014-03-12)

* First open source release to [RubyGems](https://rubygems.org)

## v0.1.1 (2014-03-07)

* Bug fix: ignore any configured resource owner password credentials during
  token validation.

## v0.1.0 (2014-02-26)

* Implement Rails API helpers
* Renamed `G5AuthenticatableApi::GrapeHelpers` to
  `G5AuthenticatableApi::Helpers::Grape`

## v0.0.1 (2014-02-20)

* Initial release with Grape API helpers
