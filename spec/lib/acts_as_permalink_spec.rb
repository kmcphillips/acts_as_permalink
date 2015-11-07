require 'spec_helper'

describe Acts::Permalink do
  describe "default attributes" do
    class Post < ActiveRecord::Base
      acts_as_permalink
    end

    it "sets the normal permalink" do
      record = Post.new(title: "Test post 1!")
      expect(record.permalink).to be_nil
      record.save!
      expect(record.permalink).to eq("test-post-1")
    end

    it "avoids a collision by adding a number" do
      Post.create!(title: "collision")
      record = Post.create!(title: "collision")
      expect(record.permalink).to eq("collision-1")
    end

    it "shortens the value to the default max_length" do
      record = Post.create!(title: ("a" * 300))
      expect(record.permalink).to eq("a" * 60)
    end

    it "cleanly handelizes a sentence" do
      record = Post.create!(title: "#}@^&*)(it's a VERY nice day today!! Let's go outside!@$%^*")
      expect(record.permalink).to eq("it-s-a-very-nice-day-today-let-s-go-outside")
    end

    it "adheres to the max_length option even if adding a number for a collision" do
      Post.create!(title: ("b" * 300))
      record = Post.create!(title: ("b" * 300))
      expect(record.permalink).to eq("#{ "b" * 58 }-1")
    end

    it "makes a random permalink if the source is blank" do
      record = Post.create!(title: "")
      expect(record.permalink).to_not be_blank
      expect(record.permalink).to match(/^post-\d+$/)
    end
  end

  describe "column with some custom properties" do
    class LongThing < ActiveRecord::Base
      acts_as_permalink max_length: 100, underscore: true
    end

    it "adheres to the max_length option even if adding a number for a collision" do
      long_title = "a" * 300
      expect(LongThing.create!(title: long_title).permalink).to eq("a" * 100)
      expect(LongThing.create!(title: long_title).permalink).to eq("#{ "a" * 98 }_1")
      expect(LongThing.create!(title: long_title).permalink).to eq("#{ "a" * 98 }_2")
      7.times{ LongThing.create!(title: long_title) }
      expect(LongThing.create!(title: long_title).permalink).to eq("#{ "a" * 97 }_10")
    end

    it "does not truncate if the title is short" do
      title = "bbb"
      expect(LongThing.create!(title: title).permalink).to eq(title)
      expect(LongThing.create!(title: title).permalink).to eq("bbb_1")
      expect(LongThing.create!(title: title).permalink).to eq("bbb_2")
      7.times{ LongThing.create!(title: title) }
      expect(LongThing.create!(title: title).permalink).to eq("bbb_10")
    end

    it "replaces with an underscore if asked to do so" do
      expect(LongThing.create!(title: "it's an underscore!").permalink).to eq("it_s_an_underscore")
    end
  end

  describe "single table inheritance" do
    class Thing < ActiveRecord::Base
      acts_as_permalink
    end

    class SpecificThing < Thing
    end

    it "creates the permalink for the subclass" do
      record = SpecificThing.create! title: "the title"
      expect(record.permalink).to eq("the-title")
    end

  end

  describe "custom attributes" do
    class OtherPost < ActiveRecord::Base
      self.table_name = "posts"
      acts_as_permalink to: :other_permalink, from: :other_title
    end

    it "works for custom attributes" do
      record = OtherPost.new(other_title: "Other post")
      expect(record.other_permalink).to be_nil
      record.save!
      expect(record.permalink).to be_nil
      expect(record.other_permalink).to eq("other-post")
    end
  end

  describe "regular models" do
    class NormalThing < ActiveRecord::Base
    end

    it "does not affect other ActiveRecord models" do
      thing = NormalThing.create!(title: "the title")
      expect(thing.to_param).to eq(thing.id.to_s)
      expect(thing).to_not respond_to(:build_permalink)
    end
  end

end
