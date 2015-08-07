module MusicIds
  class ISRC
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
  end
end
