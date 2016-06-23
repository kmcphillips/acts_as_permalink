class String
  def to_permalink(max_length: nil, separator: "-")
    Acts::Permalink::Conversion.convert(self.dup, max_length: max_length, separator: separator)
  end
end
