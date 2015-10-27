class String
  def to_permalink(max_length: nil, separator: "-")
    text = self.dup

    text = ActiveSupport::Inflector.transliterate(text)  # convert to simplified characters
    text = text.downcase.strip                           # make the string lowercase and scrub white space on either side
    text = text.gsub(/[^a-z0-9]/, separator)             # make any character that is not nupermic or alphabetic into a special character
    text = text.squeeze(separator)                       # removes any consecutive duplicates of the special character
    text = text.sub(Regexp.new("^#{ separator }+"), "")  # remove leading special characters
    text = text.sub(Regexp.new("#{ separator }+$"), "")  # remove trailing special characters
    text = text[0...max_length] if max_length            # trim to length

    text
  end
end
