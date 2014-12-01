[![Gem Version](https://badge.fury.io/rb/rails_validations.svg)](http://badge.fury.io/rb/rails_validations)
[![Build Status](https://travis-ci.org/bluerail/rails_validations.svg)](https://travis-ci.org/bluerail/rails_validations)
[![Dependency Status](https://gemnasium.com/bluerail/rails_validations.svg)](https://gemnasium.com/bluerail/rails_validations)
[![Inline docs](http://inch-ci.org/github/bluerail/rails_validations.svg?branch=master)](http://inch-ci.org/github/bluerail/rails_validations)


A few extra validations for Rails.

We try to do the ‘sane’ thing by not being too strict, when in doubt, we accept
input as being valid. We never want to reject valid input as invalid.

For many formats doing a 100% foolproof check is not trivial, email addresses
are a famous example, but it also applies to other formats.  
Regardless, you can never be sure it’s what the user *intended* anyway. For
example, email validators will accept `artin@ico.nl` as being ‘valid’, even
though my email address is `martin@lico.nl.`.  


date
----
Validate if a column is a valid date, and if it’s before or after another date.

    validates :date_column, date: true
    validates :date_column, date: { after: Date.today }
    validates :date_column, date: { after_or_equal_to: Date.today }
    validates :date_column, date: { equal_to: Date.today }
    validates :date_column, date: { before: Date.today }
    validates :date_column, date: { before_or_equal_to: Date.today }

Check if the column `enddate` is after the value of the column `begindate`:

    validates :begindate, date: true
    validates :enddate, date: { after: :begindate }


domain
------
Validate if a string looks like a valid domain. This should work with [IDN](idn).

This will accept `lico.nl`, but rejects `martin@lico.nl`:

    validates :domain_column, domain: true

Set a minimum/maximum number of domain parts (aka. labels), this will accept
`lico.nl`, but rejects `lico`:

    validates :domain_column, domain: { min_domain_parts: 2 }

Accept `lico.nl`, but reject `www.lico.nl`:

    validates :domain_column, domain: { max_domain_parts: 2 }


email
-----
Validate if a string looks liek an email address. This should work with unicode
addresses ([RFC 6531][rfc6531], [IDN][idn]).

Accepts `martin@lico.nl`, but rejects `martinlico.nl` or `martin@lico`

    validates :email_column, email: true


iban
----
Check if this is a valid IBAN account number. This uses the
[iban-tools][iban-tools] gem.

    validates :iban_column, iban: true


phone
-----
Check if this is a valid phone number. This should work with most, if not all,
writing conventions. We consider a phone to be valid if it consists of numbers &
any number of ` \-.()`; a country code at the start indicated with `+` is also
accepted.

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

version 1.1.2, 20141201
-----------------------
- Fix typo in Dutch translation.
- Update some docs.


version 1.1.1, 20141013
-----------------------
- Fix i18n key for `phone`.
- Allow passing a Proc to `date` without an argument.


version 1.1, 20141003
---------------------
- Make the date validation work if the column it points to is `nil`.
- Add documentation.


version 1.0, 20140905
---------------------
- Initial release.


[idn]: http://en.wikipedia.org/wiki/Internationalized_domain_name).
[rfc6531]: https://tools.ietf.org/html/rfc6531
[iban-tools]: https://github.com/iulianu/iban-tools
