### Development
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.3.0...main)

### 1.3.0 / 2025-08-07
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.2.1...v1.3.0)

Enhancements:

* Support `read_attribute`. (Nour E-Din El-Nhass, rspec/rspec-activemodel-mocks#66)

### 1.2.1 / 2024-10-02
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.2.0...v1.2.1)

Bug fixes:

* Fix `===` to work with multiple mocks. (@bquorning, #61)

### 1.2.0 / 2023-12-10
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.1.0...v1.2.0)

Enhancements:

* Rails 7+ support. (Jon Rowe, #56)
* Rails 6+ support, (Jon Rowe, #50)

Bug fixes:

* mock_model stubs `===` on the klass to ensure case equality works. (Jon Rowe, #55)
* Prefer File.exist? to avoid deprecation. (Olle Jonsson, #49)
* Add missing project metadata to the gemspec. (Orien Madgwick, #34)
* Make `blank?` behave like (be mocked like) `empty?`. (@lulalala, #29)

### 1.1.0 / 2018-09-17
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.0.3...v1.1.0)

Enhancements:

* Support Rails 5.x. (Jon Rowe, #33)

### 1.0.3 / 2016-01-28
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.0.2...v1.0.3)

Bug fixes:

* Fix stubbing / mocking models without a primary key. (Andrew Blignaut, #13)

### 1.0.2 / 2015-09-09
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.0.1...v1.0.2)

Bug fixes:

* Fix mocking `belongs_to` associations in Rails 4.2+. (JonRowe, #19)
* Removed deprecated option from `rspec-activemodel-mocks.gemspec`. (@taki, #14)

### 1.0.1 / 2014-06-02
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/v1.0.0...v1.0.1)

Bug fixes:

* Support RSpec 2.99. (Thomas Holmes)

### 1.0.0 / 2014-06-02
[Full Changelog](https://github.com/rspec/rspec-activemodel-mocks/compare/extract-from-rspec-rails...v1.0.0)

First release of the extracted `rspec-activemodel-mocks` from `rspec-rails`. (Thomas Holmes)
