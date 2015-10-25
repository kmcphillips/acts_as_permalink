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
      expect(record.permalink).to eq("collision1")
    end

    it "should shorten the value to the default max_length" do
      record = Post.create!(title: ("a" * 250))
      expect(record.permalink).to eq("a" * 60)
    end

    it "adheres to the max_length option even if adding a number for a collision" do
      skip
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
