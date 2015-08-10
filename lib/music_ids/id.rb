module MusicIds
  module Id
    module ClassMethods
      # Parse an identifier string into an instance
      #
      # @param input [String] The input identifier string to parse
      # @param opts [Hash] Parsing options
      # @option opts [true, false] :relaxed (false) Whether to parse in relaxed mode
      # @return [ISRC] the ISRC instance
      def parse(input, opts = {})
        input = input.to_s.upcase
        opts[:relaxed] ? parse_relaxed(input) : parse_strict(input)
      end

      private

      def parse_strict(input)
        if well_formed_id_matcher.match(input)
          new(input.gsub('-', ''))
        else
          raise ArgumentError, "'#{input}' is not the right length to be a #{self.class}"
        end
      end

      def parse_relaxed(input)
        if well_formed_id_matcher.match(input)
          new(input.gsub('-', ''))
        else
          new(input, ok: false)
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    # @api private
    # @param isrc_string [String] The ISRC string
    # @param opts [Hash]
    # @option opts [true, false] :ok (true) Whether the ISRC is well-formed or not
    def initialize(id_string, opts = {ok: true})
      @id_string = id_string.dup.freeze
      @ok = opts[:ok] ? true : false
    end

    # Is this a well-formed ID?
    # @return [true,false]
    def ok?
      @ok
    end

    # return the ID as a normalised string
    # @return [String]
    def to_s
      @id_string.dup
    end

    def ==(other)
      to_s == other.to_s
    end

    # Returns the ID as a string, either as the normalised canonical string
    # (:data) or the format specified for 'full' display (:full). Note that a
    # badly-formed ID will simply return the original string whichever format
    # you ask for.
    # @param format [:data, :full] the output format to use
    # @return [String]
    def as(format)
      case format
      when :data
        to_s
      when :full
        ok? ? as_full : to_s
      else
        raise ArgumentError, "format must be one of [:data, :full], but it was #{format.inspect}"
      end
    end

    private

    def fetch(ivar)
      return unless ok?
      return instance_variable_get(ivar) if instance_variable_defined?(ivar)
      instance_variable_set(ivar, yield(@id_string).freeze)
    end
  end
end