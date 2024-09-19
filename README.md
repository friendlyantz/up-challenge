# Installation

Latest `Ruby 3.3.5` used and is required as per `Gemfile` spec

## TLDR

```
make install
make run

make open
# or go to http://localhost:4567/
```

Refer `Makefile` for installation and usage instructions => in terminal just run `make` to see all available commands

```sh
$ make
_____________________________________________
Hi friendlyantz! Welcome to up-challenge

Getting started

make install                  install dependencies
make run                      run server
make open                     open app
make lint                     lint app
make test                     test app
```

<img width="555" alt="image" src="https://github.com/user-attachments/assets/58448fde-46dd-4b3d-89ad-c1085f442696">
<img width="440" alt="image" src="https://github.com/user-attachments/assets/8b461e75-660a-4fb7-a4fd-0b9c2e1316f8">

# Functional requirements

- [ ] functioning copy of [Bendigobank deposit and savings calculator]( <https://www.bendigobank.com.au/calculators/deposit-and-savings/>)
- [ ] UI tool that takes user input and returns (confirmed with Eddie web UI is required)
- [ ] Select the type of deposit (Cash Savings or Term Deposit)
- [ ] Input Form changes depending on the type of account selected
- [ ] Provide a summary of the total interest earned and the final balance
- [ ] Provide monthly breakdown of the interest earned

# Non-Functional requirements

1. Simplicity
1. Test Coverage
1. Error Handling
1. Usability / Documentation

---

# Consideration and Dev Notes

- Choose 'boring' technologies with minimal dependencies
  - minimal Ruby setup without extra libraries
  - Rspec + Capybara for testing
  - simplecov for test coverage
  - money calculations: Money gem
  - Rack or Sinatra with WebRick or Puma for web server, instead of Rails / Hanami. I would prefer puma over webrick, but webrick is good enough and comes with Ruby by default
  - HTMX for AJAX as it sticks original HTML principles, Turbo is also an option, but a bit more involved.

# Assumptions

- this is marketing / estimation tool, so no requirement for account ledger or transaction history
- currency is in AUD, with _Currency Exponent_ of 2

# Object Orineted design

- assign objects to represent different bussiness domain concepts, and try to avoid creating god objects
- I believe we need to differentiate between monthly breakdown of interest earned vs actual compounding periods, monthly breakdown is for presentation purposes, while actual compounding periods are for calculations

![image](https://github.com/user-attachments/assets/a1410455-49f3-4c14-8d31-5d99f0bcac9f)

# Money

Money calcs is a sensitive subject with rounding error accumulating quickly if being not careful. Some might argue that BigDecimal is ok to use, like BigIntijer in Java/Kotlin, but best practice in Ruby is to use [Money gem](https://github.com/RubyMoney/money), which has "infinite" precision settings(not default though)

```
Money.default_infinite_precision = true
```

Also best practice to handle money in `cents` and remove _Currency Exponent_ (see [ISO 4217](https://www.six-group.com/en/products-services/financial-information/data-standards.html)  for more information)

> i.e. 1US dollar 23 cents = 123, and 123 JPY is always 123, since JPY has no cents / _Currency Exponent_ is 0

I am allowing user to provide amount in dollars, and converting it to money object using `Money.from_amount` method, to account for different currency Exponents

# UI

I have been advised that UI is required and CLI tool
I have chosen HTMX due to time timations and it's ability to ajax rerender part of the page quickly based on form field changes

## Other

- validations: i wanted to use dry validations, but encountered a few issues with params hash(with indiffirent access),so decided to stick to ActiveModel::Validations
- Linting: due to time constraint relying on autolinting by rubocop, with some rules overrides and sticking to keeping some default rules that might be an overkill (i.e. frozen string literals for cases when there re no frozen strings at all). RSpec/MultipleExpectations ignored as I like to have BDD spec telling a user flow story, and not just a single expectation per test. RSpec/NamedSubject: I like to be explicit about what I am testing.

# Test Coverage

`simpleCov` - added coverage although not a fan of this as if you write your code BDD/TDD you would expect to have almost double coverage of all the lines. The current coverage reports

> All Files ( 100.0% covered at  1.61 hits/line)

# Future Work

- Cash weekly/ fortnightly compounding display monthly
- UI improvements
- Refactor term deposit
- Handle CSV, JSON
- year/month form picker

# Retrospective

- writing quality software is hard
- spent a lot more time on the inital analysis and repository setup then I would have hoped or imagined but it was definitely worth thinking about the problem
- quite happy with commits, but could have been more granular
- would have been good to focus on some new libraries: validation with dry-validation or similar, or some variations on the boring approach: writing out a full ledger of all transactions maybe ¯_(ツ)_/¯
- overall reasonably happy with the setup and the functionality of the code, given the time constraints
