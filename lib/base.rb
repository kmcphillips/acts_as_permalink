require "config"
require "conversion"
require "concern"

ActiveRecord::Base.send(:include, Acts::Permalink)
