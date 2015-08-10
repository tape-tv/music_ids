module MusicIds
  # The GRid class represents a Global Release Identifier, and
  # provides simple methods to parse and re-present them.
  #
  # == What is a GRid?
  # GRid's are unique identifiers for Releases of recorded music, as distinct
  # from different Products (See the GRid Handbook for more details). They're
  # often used as key identifiers in the delivery and reporting of digital
  # music products.
  #
  # You can get more details from 
  # https://en.wikipedia.org/wiki/Global_Release_Identifier and
  # http://www.ifpi.org/grid.php
  #
  # == Well-formedness and validity
  # GRid's are supposed to be able to be looked up in a global database, so we
  # need to draw a distinction between *valid* GRid's, which are GRid's we have
  # looked up and verified in that database, and well-formed GRid's, which are
  # just strings that match the requirements above.
  #
  # Checking or enforcing validity is beyond the scope of this class.
  # Well-formedness, on the other hand, is easy to check and enforce.
  #
  # While you don't want to be emitting badly-formed GRid's, if you handle
  # GRid's from elsewhere you may well run across bad metadata that you need to
  # preserve, but probably want to be aware of the fact that it's bad.
  #
  # To help with that there are two parsing modes, strict (the default), and
  # relaxed.
  #
  # In strict parsing mode, <tt>GRid.parse</tt> will raise an error if passed a
  # badly-formed GRid string. In relaxed mode, it will return an <tt>GRid</tt>
  # instance that will return <tt>false</tt> from <tt>#ok?</tt> and will return
  # nil from all the component methods like <tt>#issuer</tt>
  class GRid
    # See http://www.ifpi.org/downloads/GRid_Standard_v2_1.pdf §5
    WELL_FORMED_INPUT = /\AA1-?[A-Z0-9]{5}-?[A-Z0-9]{10}-?[A-Z0-9]\Z/

    class << self
      # Parse a GRid string into a GRid instance
      #
      # @param input [String] The input GRid string to parse
      # @param opts [Hash] Parsing options
      # @option opts [true, false] :relaxed (false) Whether to parse in relaxed mode
      # @return [GRid] the grid instance
      def parse(input, opts = {})
        input = input.to_s.upcase
        opts[:relaxed] ? parse_relaxed(input) : parse_strict(input)
      end

      private

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

    # @api private
    # @param grid_string [String] The GRid string
    # @param opts [Hash]
    # @option opts [true, false] :ok (true) Whether the GRid is well-formed or not
    def initialize(grid_string, opts = {ok: true})
      @grid_string = grid_string.dup.freeze
      @ok = opts[:ok] ? true : false
    end

    # Is this a well-formed GRid?
    # @return [true,false]
    def ok?
      @ok
    end

    # Return the GRid's two-letter scheme identifier
    # @return [String]
    def scheme
      return unless ok?
      @scheme ||= @grid_string[0,2].freeze
    end

    # Return the GRid's 5-character issuer code
    # @return [String]
    def issuer
      return unless ok?
      @issuer ||= @grid_string[2,5].freeze
    end

    # Return the GRid's 10-character release number.
    # @return [String]
    def release
      return unless ok?
      @release ||= @grid_string[7,10].freeze
    end

    # Return the GRid's check character.
    # @return [String]
    def check
      return unless ok?
      @check ||= @grid_string[17,1].freeze
    end

    # return the GRid as a normalised 18-character string
    # @reuturn [String]
    def to_s
      @grid_string.dup
    end

    def to_grid
      self
    end

    def ==(other)
      to_s == other.to_s
    end

    # Returns the GRid as a string, either the 18-character normalised string
    # (:data) or the 21-character display string (:full). Note that a
    # badly-formed GRid will simply return the original string whichever format
    # you ask for.
    # @param format [:data, :full] the output format to use
    # @return [String]
    def as(format)
      case format
      when :data
        to_s
      when :full
        ok? ? "#{scheme}-#{issuer}-#{release}-#{check}" : to_s
      else
        raise ArgumentError, "format must be one of [:data, :full], but it was #{format.inspect}"
      end
    end
  end
end
