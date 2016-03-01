# ​![](http://i.imgur.com/ROJdCFe.png?1) MusicIds

[![Build Status](https://travis-ci.org/tape-tv/music_ids.svg)](https://travis-ci.org/tape-tv/music_ids)
[![Code Climate](https://codeclimate.com/github/tape-tv/music_ids/badges/gpa.svg)](https://codeclimate.com/github/tape-tv/music_ids)
[![Test Coverage](https://codeclimate.com/github/tape-tv/music_ids/badges/coverage.svg)](https://codeclimate.com/github/tape-tv/music_ids/coverage)
[![Gem Version](https://badge.fury.io/rb/music_ids.svg)](http://badge.fury.io/rb/music_ids)
[![Docs](http://inch-ci.org/github/tape-tv/music_ids.svg?branch=master)](http://inch-ci.org/github/tape-tv/music_ids)

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

Problems with your ID will raise an ArgumentError on parsing

```ruby
require 'music_ids'

begin
  isrc = MusicIds::ISRC.parse('FRZ03')
rescue ArgumentError => e
  e.message
end
#=> "'FRZ03' is not the right length to be a MusicIds::ISRC"

begin
  grid = MusicIds::GRid.parse('A12425G')
rescue ArgumentError => e
  e.message
end
#=> "'A12425G' is not the right length to be a MusicIds::GRid"
```

If you have to sometimes deal with bad metadata, then you may want a more
forgiving approach. Enter 'relaxed' parsing. You can pass `relaxed: true` as an
options hash to `.parse`, or you can call `.relaxed` directly. A 'bad' instance
returned by relaxed mode parsing reports that it's not ok with `#ok?` and won't
return any components, and will only return the input string it was passed and
not the full or prefixed versions you can get for a well-formed ISRC.

```ruby
require 'music_ids'

bad_isrc = MusicIds::ISRC.parse('bad', relaxed: true)
bad_isrc.ok?           #=> false
bad_isrc.to_s          #=> 'bad'
bad_isrc.country       #=> nil
bad_isrc.as(:data)     #=> 'bad'
bad_isrc.as(:full)     #=> 'bad'
bad_isrc.as(:prefixed) #=> 'bad'

other_bad_isrc = MusicIds::ISRC.relaxed('bad')
other_bad_isrc.ok?     #=> false
other_bad_isrc.to_s    #=> 'bad'

bad_grid = MusicIds::GRid.parse('bad', relaxed: true)
bad_grid.ok?           #=> false
bad_grid.to_s          #=> 'bad'
bad_grid.scheme        #=> nil
bad_grid.as(:data)     #=> 'bad'
bad_grid.as(:full)     #=> 'bad'
bad_grid.as(:prefixed) #=> 'bad'

other_bad_grid = MusicIds::GRid.relaxed('bad')
other_bad_grid.ok?     #=> false
other_bad_grid.to_s    #=> 'bad'

MusicIds::ISRC.relaxed(nil) #=> nil
MusicIds::GRid.relaxed(nil) #=> nil

# Of course, parsing valid IDs in relaxed mode works just fine:
MusicIds::ISRC.relaxed('FRZ039800212').ok?       #=> true
MusicIds::GRid.relaxed('A12425GABC1234002M').ok? #=> true

# And strict parsed instances can tell you they're okay
MusicIds::ISRC.parse('FRZ039800212').ok?         #=> true
MusicIds::GRid.parse('A12425GABC1234002M').ok?   #=> true
```

For more details, see the [RDoc](http://www.rubydoc.info/gems/music_ids).

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
