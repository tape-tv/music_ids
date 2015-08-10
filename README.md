# MusicIds

`music_ids` contains classes that represent some of the main ID formats in use in the music industry for identifying individual pieces of recorded music.

There are often several ways that these IDs can be written, so the classes provide standard APIs to parse and normalise ID strings, as well as to break them into their components.

Currently we offer a class for the ISRC (International Standard Recording Code).

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
(See API docs at <http://www.rubydoc.info/gems/music_ids> for more details including links to the relevant ID specifications.)

```ruby
require 'music_ids'

isrc = MusicIds::ISRC.parse('FRZ039800212')
isrc.country #=> 'FR'
isrc.registrant #=> 'Z03'
isrc.year #=> '98'
isrc.designation #=> '00212'

other = ISRC.parse('FR-Z03-98-00212')
other.registrant #=> 'Z03'

isrc == other #=> true

isrc.to_s #=> 'FRZ039800212'
isrc.as(:full) #=> 'FR-Z03-98-00212'
```

## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
1. Fork it ( https://github.com/[my-github-username]/music_ids/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
