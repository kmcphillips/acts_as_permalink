module Acts
  module Permalink
    module Conversion
      class << self
        def convert(string, max_length: nil, separator: "-")
          string = ActiveSupport::Inflector.transliterate(string)  # convert to simplified characters
          string = string.downcase.strip                           # make the string lowercase and scrub white space on either side
          string = string.gsub(/[^a-z0-9]/, separator)             # make any character that is not nupermic or alphabetic into a special character
          string = string.squeeze(separator)                       # removes any consecutive duplicates of the special character
          string = string.sub(Regexp.new("^#{ separator }+"), "")  # remove leading special characters
          string = string.sub(Regexp.new("#{ separator }+$"), "")  # remove trailing special characters
          string = string[0...max_length] if max_length            # trim to length

          string
        end
      end
    end
  end
end
