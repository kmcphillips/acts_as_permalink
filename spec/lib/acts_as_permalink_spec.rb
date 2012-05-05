require 'spec_helper'

describe Acts::Permalink do
  describe "default attributes" do
    
    class Post < ActiveRecord::Base
      attr_accessible :title, :permalink
      acts_as_permalink
    end

    it "should set the normal permalink" do
      t = Post.new :title => "Test post 1!"
      t.permalink.should be_nil
      t.save!
      t.permalink.should == "test_post_1"
    end

    it "should avoid a collision" do
      Post.create! :title => "collision"
      t = Post.create! :title => "collision"
      t.permalink.should == "collision1"
    end

    it "should shorten it" do
      t = Post.create! :title => ("a" * 250)
      t.permalink.should == ("a" * 60)
    end

  end

  describe "custom attributes" do
    class OtherPost < ActiveRecord::Base
      self.table_name = "posts"
      attr_accessible :other_title, :other_permalink
      acts_as_permalink :to => :other_permalink, :from => :other_title
    end

    it "should work too" do
      t = OtherPost.new :other_title => "Other post"
      t.other_permalink.should be_nil
      t.save!
      t.permalink.should be_nil
      t.other_permalink.should == "other_post"
    end
  end

end
