[![Gem Version](https://badge.fury.io/rb/rails_validations.svg)](http://badge.fury.io/rb/rails_validations)
[![Build Status](https://travis-ci.org/bluerail/rails_validations.svg)](https://travis-ci.org/bluerail/rails_validations)
[![Dependency Status](https://gemnasium.com/bluerail/rails_validations.svg)](https://gemnasium.com/bluerail/rails_validations)
[![Inline docs](http://inch-ci.org/github/bluerail/rails_validations.svg?branch=master)](http://inch-ci.org/github/bluerail/rails_validations)


A few extra validations for Ruby on Rails. Works with Ruby 2.1+ & Rails 4+.

We try to do the sane thing by not being too strict, when in doubt, we accept
input as being valid. We never want to reject valid input as invalid.

For many formats doing a 100% foolproof check is not trivial, email addresses
are a famous example, but it also applies to other formats.  
Regardless, you can never be sure it’s what the user *intended* anyway. For
example, email validators will accept `artin@ico.nl` as being ‘valid’, even
though my email address is `martin@lico.nl`.  


I18N
====
The gem includes English and Dutch error messages. If you want to translate it
to another language then copy [`config/locales/en.yml`][tr] to your project.
Please send us your translations so we can add them!

[tr]: https://github.com/bluerail/rails_validations/blob/master/config/locales/en.yml


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

**Note** Since version 2.0, this gem no longer depends on iban-tools.  If you
want IBAN validations, then you must add `gem iban-tools` it to your Gemfile
manually.

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


commerce\_number
---------------
Check if this is a valid chamber of commerce identification number.

    validates :commerce_number_column, commerce_number: { country: :nl }

Currently implemented countries:

- `nl` - The Netherlands


vat\_number
-----------
Check if this is a valid [VAT identification number](https://en.wikipedia.org/wiki/VAT_identification_number)

    validates :vat_number_column, vat_number: { country: :nl }

Currently implemented countries:

- `nl` - The Netherlands


ChangeLog
=========

Version 2.2, 2017-08-28
-----------------------
- Fix deprecation warning on Fixnum by checking against Integer instead.
- Dropped Ruby 1.9 & 2.0 support
- Dropped Rails 3 support

Version 2.0, 2015-08-19
-----------------------
- Don't depend on the `iban-tools` gem. If you want IBAN validations, then you
  must add `gem iban-tools` to your Gemfile manually (this is the only change,
  but since it's incompatible I bumped the version to 2.0).


Version 1.4, 2015-08-11
-----------------------
- Make it work with Ruby 1.9 and Rails 3.0


Version 1.3, 2015-05-22
-----------------------
- Add `commerce_number` validation.
- Add `vat_number` validation.
- The `postal_code` validation will now raise an error if an invalid country
  code is given.


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
