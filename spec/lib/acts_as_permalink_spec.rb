require 'spec_helper'

describe Acts::Permalink do
  describe "default attributes" do

    class Post < ActiveRecord::Base
      acts_as_permalink
    end

    it "sets the normal permalink" do
      record = Post.new title: "Test post 1!"
      expect(record.permalink).to be_nil
      record.save!
      expect(record.permalink).to eq("test_post_1")
    end

    it "avoids a collision by adding a number" do
      Post.create! title: "collision"
      record = Post.create!(title: "collision")
      expect(record.permalink).to eq("collision-1")
    end

    it "should shorten the value to the default max_length" do
      record = Post.create!(title: ("a" * 300))
      expect(record.permalink).to eq("a" * 60)
    end

    it "adheres to the max_length option even if adding a number for a collision" do
      Post.create!(title: ("b" * 300))
      record = Post.create!(title: ("b" * 300))
      expect(record.permalink).to eq("#{ "b" * 58 }-1")
    end

  end

  describe "column with max_length property" do
    class LongThing < ActiveRecord::Base
      acts_as_permalink max_length: 100
    end

    it "adheres to the max_length option even if adding a number for a collision" do
      long_title = "a" * 300
      expect(LongThing.create!(title: long_title).permalink).to eq("a" * 100)
      expect(LongThing.create!(title: long_title).permalink).to eq("#{ "a" * 98 }-1")
      expect(LongThing.create!(title: long_title).permalink).to eq("#{ "a" * 98 }-2")
      7.times{ LongThing.create!(title: long_title) }
      expect(LongThing.create!(title: long_title).permalink).to eq("#{ "a" * 97 }-10")
    end

    it "does not truncate if the title is short" do
      title = "bbb"
      expect(LongThing.create!(title: title).permalink).to eq(title)
      expect(LongThing.create!(title: title).permalink).to eq("bbb-1")
      expect(LongThing.create!(title: title).permalink).to eq("bbb-2")
      7.times{ LongThing.create!(title: title) }
      expect(LongThing.create!(title: title).permalink).to eq("bbb-10")
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
      expect(record.permalink).to eq("the_title")
    end

  end

  describe "custom attributes" do
    class OtherPost < ActiveRecord::Base
      self.table_name = "posts"
      acts_as_permalink to: :other_permalink, from: :other_title
    end

    it "works for custom attributes" do
      record = OtherPost.new other_title: "Other post"
      expect(record.other_permalink).to be_nil
      record.save!
      expect(record.permalink).to be_nil
      expect(record.other_permalink).to eq("other_post")
    end
  end

end
