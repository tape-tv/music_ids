# MusicIds

[![Build Status](https://travis-ci.org/tape-tv/music_ids.svg)](https://travis-ci.org/tape-tv/music_ids)[![Code Climate](https://codeclimate.com/github/tape-tv/music_ids/badges/gpa.svg)](https://codeclimate.com/github/tape-tv/music_ids)[![Test Coverage](https://codeclimate.com/github/tape-tv/music_ids/badges/coverage.svg)](https://codeclimate.com/github/tape-tv/music_ids/coverage)[![Gem Version](https://badge.fury.io/rb/music_ids.svg)](http://badge.fury.io/rb/music_ids) [RDoc](http://www.rubydoc.info/gems/music_ids)

`music_ids` contains classes that represent some of the main ID formats in use in the music industry for identifying individual pieces of recorded music.

There are often several ways that these IDs can be written, so the classes provide standard APIs to parse and normalise ID strings, as well as to break them into their components.

Currently we have classes for the ISRC (International Standard Recording Code) and GRid (Global Release Identifier).

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'music_ids'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install music_ids

## Usage
(See API docs at <http://www.rubydoc.info/gems/music_ids> for more details
including links to the relevant ID specifications.)

`MusicIds::GRid` and `MusicIds::ISRC` have the same basic API pattern: a
`parse` class method, `to_s` returns normalised string version of the ID and
`as(format)` returns different string representations of the Id.

Instances compare equal if their normalised string representations match.
Parsing an existing instance just returns another instance of the same ID.

```ruby
require 'music_ids'

isrc = MusicIds::ISRC.parse('FRZ039800212')
isrc.country     #=> 'FR'
isrc.registrant  #=> 'Z03'
isrc.year        #=> '98'
isrc.designation #=> '00212'

other = ISRC.parse('FR-Z03-98-00212')
other.registrant #=> 'Z03'

isrc == other #=> true

isrc.to_s #=> 'FRZ039800212'
isrc.as(:full) #=> 'FR-Z03-98-00212'

MusicIds::ISRC.parse(isrc) == isrc #=> true

grid_with_hyphens = MusicIds::GRid.parse('A1-2425G-ABC1234002-M')
grid =              MusicIds::GRid.parse('A12425GABC1234002M')
# You do see this form with GRids
grid_with_prefix =  MusicIds::GRid.parse('GRID:A1-2425G-ABC1234002-M')

grid.scheme  #=> 'A1'
grid.issuer  #=> '2425G'
grid.release #=> 'ABC1234002'
grid.check   #=> 'M'

grid_with_hyphens == grid #=> true
grid_with_prefix == grid #=> true

grid.to_s #=> 'A12425GABC1234002M'
grid.as(:full) #=> 'A1-2425G-ABC1234002-M'
grid.as(:prefixed) #=> 'GRID:A1-2425G-ABC1234002-M'

MusicIds::GRid.parse(grid) == grid #=> true
```

Support for `as_json` is included so the basic JSON generation case will work:

```ruby
require 'music_ids'
require 'json'


isrc = MusicIds::ISRC.parse('FRZ039800212')
grid = MusicIds::GRid.parse('A12425GABC1234002M')

isrc.as_json #=> 'FRZ039800212'
grid.as_json #=> 'A12425GABC1234002M'

JSON.generate({isrc: isrc, grid: grid})
#=> "{\"isrc\":\"FRZ039800212\",\"grid\":\"A12425GABC1234002M\"}"
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git
commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing
1. Fork it ( https://github.com/[my-github-username]/music_ids/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
