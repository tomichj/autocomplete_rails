# AutocompleteRails Changelog

## [0.4.1] - June 8, 2018

### Cleanup
- removed a tilde file mistakenly left in the 0.4.0 build
- incremented version to 0.4.1 for a clean gem
- rakefile fixes for build and deploy



## [0.4.0] - June 5, 2018

### Rails 5.2 support
- added 5.2 to Appraisals, added 5.2 gemfile
- added build and release tasks to Rakefile
- moved from factory_girl to factory_bot, incremented version file
- deprecation fixes for 5.2:
    - wrapping sql for order() in Arel.sql
    - Rails.application.config.active_record.sqlite3.represent_boolean_as_integer = true
      in dummy app for specs
    - specs, be_success to have_http_status(200)



## [0.3.1] - October 5, 2017

### New feature: scopes with parameters
- scopes can be defined using parameters
- autocomplete can be followed by a block which is evaluated to further
  refine results

### Minor updates:
- updated readme: add jquery-rails url, cleaning up example search tag
- incrementing version
- added appraisal, begin running tests against many rails versions
- moved tests exercising api from controller to request



## [0.3.0] - March 26, 2017

### Support for rails 5.1
- bumped verison number for new gem release
- removed Gemfile.lock from git.
- very minor comments and docs cleanup



## [0.2.0] - August 3, 2016

* removed 'ESCAPE \' from query... \ appears to be default on all platforms
* documenting order, scopes
* readme now describes options for advanced usage



## [0.1.0] - May 29, 2016

Initial release. Minimal functionality completed.



[0.4.1]: https://github.com/tomichj/autocomplete_rails/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/tomichj/autocomplete_rails/compare/0.3.0...0.4.0
[0.3.1]: https://github.com/tomichj/autocomplete_rails/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/tomichj/autocomplete_rails/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/tomichj/autocomplete_rails/compare/0.1.0...0.2.0
