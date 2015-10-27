# encoding: UTF-8
require 'spec_helper'

describe String do
  describe "#to_permalink" do
    it "converts a string to a permalink" do
      expect("it's a wonderful day!!".to_permalink).to eq("it-s-a-wonderful-day")
      expect("@$#a{$%^b#$%#%c!@<>d,./".to_permalink).to eq("a-b-c-d")
    end

    it "allows overriding the separator" do
      expect("(Oh hey neat), an underscore __ character".to_permalink(separator: "_")).to eq("oh_hey_neat_an_underscore_character")
    end

    it "allows defining a max length" do
      expect("_-_-_-123456_-_-_-_".to_permalink(max_length: 3)).to eq("123")
    end

    it "uses transliteration to convert weirder characters to simple a-z" do
      expect("ümlaUT".to_permalink).to eq("umlaut")
      expect("garçon".to_permalink).to eq("garcon")
    end
  end
end
