A few extra validations for rails.

[RubyGems.org entry](http://rubygems.org/gems/rails_validations)

date
----
Validate is a column is a date, and if it's before or after another date.

    validates :date_column, date: true
    validates :date_column, date: { after: Date.today }
    validates :date_column, date: { after_or_equal_to: Date.today }
    validates :date_column, date: { equal_to: Date.today }
    validates :date_column, date: { before: Date.today }
    validates :date_column, date: { before_or_equal_to: Date.today }

    # Check if the column `enddate` is after the value of the column `begindate`
    validates :begindate, date: true
    validates :enddate, date: { after: :begindate }


domain
------
Validate if a string is a valid domain. This should work with [IDN](idn).

    validates :domain_column, domain: true

    # Set a minimum/maximum number of domain parts (aka. labels)
    validates :domain_column, domain: { min_domain_parts: 2 }
    validates :domain_column, domain: { max_domain_parts: 2 }


email
-----
Do a basic checks for emails. Not that this check is *not* very strict, it is
nigh-impossible to check if an email address is valid (and even if it is, it's
no guarantee if email actually gets delivered to this address). This should
work with unicode addresses ([RFC 6531][rfc6531], [IDN][idn]).

    validates :email_column, email: true


iban
----
Check if this is a valid IBAN account number. This uses the
[iban-tools][iban-tools] gem.

    validates :iban_column, iban: true


phone
-----
Check if this is a valid phone number. As with the Email check, this isn't
particularly strict; conventions for writing phone numbers vary a lot.

    validates :phone_column, phone: true


postal\_code
------------
Check if this is a valid postal code (or zip code for the states).

Currently implemented countries:
- `nl` - The Netherlands


    validates :postal_code_column, postal_code: { country: :nl }

    # Country defaults to I18n.locale
    validates :postal_code_column, postal_code: true



ChangeLog
=========

1.1, 20141003
-------------
- Make the date validation work if the column it points to is `nil`.
- Add documentation.


1.0, 20140905
-------------
- Initial release.

[idn]: http://en.wikipedia.org/wiki/Internationalized_domain_name).
[rfc6531]: https://tools.ietf.org/html/rfc6531
[iban-tools]: https://github.com/iulianu/iban-tools
