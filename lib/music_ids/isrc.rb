module MusicIds
  # The ISRC class represents an International Standard Recording Code, and
  # provides simple methods to parse and re-present them.
  #
  # An ISRC is a string that is supposed to uniquely identify a particular
  # audio / video recording of a piece of music. (That is, two different
  # recordings of the same song should have different ISRCs)
  #
  # ISRCs consist of four blocks of information: a two-letter country code, three-character registrant code, two-digit year (see #year), and five-digit designation code. There are two main string representations: the canonical 12-character version, and a 15-character version that inserts hyphens (-) between the blocks.
  #
  # The first two blocks identify, essentially, a record company / distributor and their country of origin, the last two blocks provide a unique recording number for that company in a particular year.
  #
  # You can get more details from
  # https://en.wikipedia.org/wiki/International_Standard_Recording_Code and
  # http://www.usisrc.org/
  class ISRC
    # See http://www.ifpi.org/content/library/isrc_handbook.pdf §3.5
    WELL_FORMED_INPUT = /\A[A-Z]{2}-?[A-Z0-9]{3}-?[0-9]{2}-?[0-9]{5}\Z/

    class << self
      # Parse an ISRC string into an ISRC instance
      #
      # @param input [String] The input ISRC string to parse
      # @return [ISRC] the ISRC instance
      def parse(input, opts = {})
        input = input.to_s.upcase
        opts[:relaxed] ? parse_relaxed(input) : parse_strict(input)
      end

      def parse_strict(input)
        if WELL_FORMED_INPUT.match(input)
          new(input.gsub('-', ''))
        else
          raise ArgumentError, "'#{input}' is not the right length to be a 12- or 15-character ISRC"
        end
      end

      def parse_relaxed(input)
        if WELL_FORMED_INPUT.match(input)
          new(input.gsub('-', ''))
        else
          new(input, ok: false)
        end
      end
    end

    def initialize(isrc_string, opts = {ok: true})
      @isrc_string = isrc_string.dup.freeze
      @ok = opts[:ok] ? true : false
    end

    # Is this a well-formed ISRC?
    # @return [true,false]
    def ok?
      @ok
    end

    # Return the ISRC's two-letter country code
    # @return [String]
    def country
      return unless ok?
      @country ||= @isrc_string[0,2].freeze
    end

    # Return the ISRC's three-character registrant code
    # @return [String]
    def registrant
      return unless ok?
      @registrant ||= @isrc_string[2,3].freeze
    end

    # Return the ISRC's two-digit year.
    #
    # Note that year > 40 is a 19YY year, and 00 to 39 are 20YY years
    # see http://www.ifpi.org/content/library/isrc_handbook.pdf section 4.8
    # @return [String]
    def year
      return unless ok?
      @year ||= @isrc_string[5,2].freeze
    end

    # Return the ISRC's five-character designation code.
    #
    # @return [String]
    def designation
      return unless ok?
      @designation ||= @isrc_string[7,5].freeze
    end

    # return the ISRC as a normalised 12-character string
    # @reuturn [String]
    def to_s
      @isrc_string.dup
    end

    def to_isrc
      self
    end

    def ==(other)
      to_s == other.to_s
    end

    # Returns the ISRC as a string, either the 12-character normalised string
    # (:data) or the 15-character display string (:full). Note that a badly-formed ISRC will simply return the original string whichever format you ask for
    # @param format [:data, :full] the output format to use
    # @return [String]
    def as(format)
      case format
      when :data
        to_s
      when :full
        ok? ? "#{country}-#{registrant}-#{year}-#{designation}" : to_s
      else
        raise ArgumentError, "format must be one of [:data, :full], but it was #{format.inspect}"
      end
    end
  end
end
