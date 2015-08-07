module MusicIds
  class ISRC
    def self.parse(input)
      input = input.to_s

      if input.length == 12
        new(input)
      elsif input.length == 15
        new(input.gsub('-', ''))
      else
        raise ArgumentError, "'#{input}' is not the right length to be a 12- or 15-character ISRC"
      end
    end

    def initialize(isrc_string)
      @isrc_string = isrc_string.dup.freeze
    end

    def country
      @country ||= @isrc_string[0,2].freeze
    end

    def registrant
      @registrant ||= @isrc_string[2,3].freeze
    end

    def year
      @year ||= @isrc_string[5,2].freeze
    end

    def designation
      @designation ||= @isrc_string[7,5].freeze
    end

    def to_s
      @isrc_string.dup
    end

    def to_isrc
      self
    end

    def ==(other)
      to_s == other.to_s
    end

    def as(format)
      case format
      when :data
        to_s
      when :full
        "#{country}-#{registrant}-#{year}-#{designation}"
      else
        raise ArgumentError, "format must be one of [:data, :full], but it was #{format.inspect}"
      end
    end
  end
end
