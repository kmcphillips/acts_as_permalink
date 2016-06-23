# encoding: UTF-8
require 'spec_helper'

describe Acts::Permalink::Conversion do
  describe ".convert" do
    it "converts a string to a permalink" do
      expect(Acts::Permalink::Conversion.convert("it's a wonderful day!!")).to eq("it-s-a-wonderful-day")
      expect(Acts::Permalink::Conversion.convert("@$#a{$%^b#$%#%c!@<>d,./")).to eq("a-b-c-d")
    end

    it "allows overriding the separator" do
      expect(Acts::Permalink::Conversion.convert("(Oh hey neat), an underscore __ character", separator: "_")).to eq("oh_hey_neat_an_underscore_character")
    end

    it "allows defining a max length" do
      expect(Acts::Permalink::Conversion.convert("_-_-_-123456_-_-_-_", max_length: 3)).to eq("123")
    end

    it "uses transliteration to convert weirder characters to simple a-z" do
      expect(Acts::Permalink::Conversion.convert("ümlaUT")).to eq("umlaut")
      expect(Acts::Permalink::Conversion.convert("garçon")).to eq("garcon")
    end
  end
end
