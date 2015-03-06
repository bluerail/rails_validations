[![Gem Version](https://badge.fury.io/rb/rails_validations.svg)](http://badge.fury.io/rb/rails_validations)
[![Build Status](https://travis-ci.org/bluerail/rails_validations.svg)](https://travis-ci.org/bluerail/rails_validations)
[![Dependency Status](https://gemnasium.com/bluerail/rails_validations.svg)](https://gemnasium.com/bluerail/rails_validations)
[![Inline docs](http://inch-ci.org/github/bluerail/rails_validations.svg?branch=master)](http://inch-ci.org/github/bluerail/rails_validations)


A few extra validations for Ruby on Rails.

We try to do the ‘sane’ thing by not being too strict, when in doubt, we accept
input as being valid. We never want to reject valid input as invalid.

For many formats doing a 100% foolproof check is not trivial, email addresses
are a famous example, but it also applies to other formats.  
Regardless, you can never be sure it’s what the user *intended* anyway. For
example, email validators will accept `artin@ico.nl` as being ‘valid’, even
though my email address is `martin@lico.nl.`.  




Available validations
=====================

date
----
Validate if a column is a valid date, and if it’s before or after another date.

    # Check if it looks like a valid date
    validates :date_column, date: true

    # We use a lambda for these checks because otherwise Date.today would be
    # evaluated *only* on startup, and not every time we run the validations
    # (you never want this).
    validates :date_column, date: { after: -> { Date.today } }
    validates :date_column, date: { after_or_equal_to: -> { Date.today } }
    validates :date_column, date: { equal_to: -> { Date.today } }
    validates :date_column, date: { before: -> { Date.today } }
    validates :date_column, date: { before_or_equal_to: -> { Date.today } }

Check if the column `enddate` is after the value of the column `begindate`:

    validates :begindate, date: true
    validates :enddate, date: { after: :begindate }


domain
------
Validate if a string looks like a valid domain. This should work with [IDN](idn).

This will accept `lico.nl`, but rejects `martin@lico.nl`:

    validates :domain_column, domain: true

Set a minimum and maximum number of domain parts (aka. labels), this will accept
`lico.nl`, but rejects `lico`:

    validates :domain_column, domain: { min_domain_parts: 2 }

Accept `lico.nl`, but reject `www.lico.nl`:

    validates :domain_column, domain: { max_domain_parts: 2 }


email
-----
Validate if a string looks like an email address. This should work with unicode
addresses ([RFC 6531][rfc6531], [IDN][idn]).

Accepts `martin@lico.nl`, but rejects `martinlico.nl` or `martin@lico`:

    validates :email_column, email: true


iban
----
Check if this is a valid IBAN account number. This uses the
[iban-tools][iban-tools] gem.

    validates :iban_column, iban: true

By default we set “not a valid IBAN account number” as the error message, but we
can also set more detailed errors:
  
    validates :iban_column, iban: { detailed_errors: true }


phone
-----
Check if this is a valid phone number. This should work with most, if not all,
writing conventions. We consider a phone to be valid if it consists of numbers &
any amount of ` \-.()` characters. A country code at the start indicated with
`+` is also accepted.

    validates :phone_column, phone: true


postal\_code
------------
Check if this is a valid postal code (or zip code for the states).

    validates :postal_code_column, postal_code: { country: :nl }

    # Country defaults to I18n.locale
    validates :postal_code_column, postal_code: true


Currently implemented countries:

- `nl` - The Netherlands


ChangeLog
=========
Version 1.2, 2015-03-07
-----------------------
- The IBAN check will now defaults to just a "is invalid" message, set the
  `detailed_errors` option to get the more detailed errors.
- Also allow emails with multiple domains (e.g. `test@hello.world.example.com`).
- Date validation now accepts a custom message.


Version 1.1.4, 2014-12-28
-------------------------
- Bugfix for Date validator when comparing to other columns that are a String.


Version 1.1.3, 2014-12-03
-------------------------
- Make sure that the date validator doesn’t throw an exception if
  `'invalid'.to_date` fails.


Version 1.1.2, 2014-12-01
-------------------------
- Fix typo in Dutch translation.
- Update some docs.


Version 1.1.1, 2014-10-13
-------------------------
- Fix i18n key for `phone`.
- Allow passing a Proc to `date` without an argument.


Version 1.1, 2014-10-03
-----------------------
- Make the date validation work if the column it points to is `nil`.
- Add documentation.


Version 1.0, 2014-09-05
-----------------------
- Initial release.


[idn]: http://en.wikipedia.org/wiki/Internationalized_domain_name).
[rfc6531]: https://tools.ietf.org/html/rfc6531
[iban-tools]: https://github.com/iulianu/iban-tools
