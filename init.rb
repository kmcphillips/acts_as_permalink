require 'acts_as_permalink'
ActiveRecord::Base.send(:include, Acts::Permalink)
