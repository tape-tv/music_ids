require 'music_ids/id'

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
    include Id

    # See http://www.ifpi.org/downloads/GRid_Standard_v2_1.pdf §5
    def self.well_formed_id_matcher
      /\AA1-?[A-Z0-9]{5}-?[A-Z0-9]{10}-?[A-Z0-9]\Z/
    end

    # Return the GRid's two-letter scheme identifier
    # @return [String]
    def scheme
      fetch(:@scheme) { |grid_string| grid_string[0,2] }
    end

    # Return the GRid's 5-character issuer code
    # @return [String]
    def issuer
      fetch(:@issuer) { |grid_string| grid_string[2,5] }
    end

    # Return the GRid's 10-character release number.
    # @return [String]
    def release
      fetch(:@release) { |grid_string| grid_string[7,10] }
    end

    # Return the GRid's check character.
    # @return [String]
    def check
      fetch(:@check) { |grid_string| grid_string[17,1] }
    end

    def to_grid
      self
    end

    # Generate the hyphen-separated full display GRid string
    # @return [String]
    def as_full
      "#{scheme}-#{issuer}-#{release}-#{check}"
    end
  end
end
