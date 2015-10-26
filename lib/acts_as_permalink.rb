require "string"
require "config"

module Acts
  module Permalink
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_permalink(options={})
        cattr_accessor :acts_as_permalink_config
        self.acts_as_permalink_config = Acts::Permalink::Config.new(options)

        before_validation :update_permalink, on: :create
        validates_uniqueness_of self.acts_as_permalink_config.to
        attr_readonly self.acts_as_permalink_config.to
      end

      def generate_permalink_for(obj)
        config = obj.class.base_class.acts_as_permalink_config

        text = obj.public_send(config.from)
        text = [obj.class.base_class.to_s, rand(10000)].join(config.separator) if text.blank?
        text = text.to_permalink(separator: config.separator, max_length: config.max_length)

        # Attempt to find the object by the permalink, and if so there is a collision and we need to de-collision it
        if obj.class.base_class.where(config.to => text).first
          candidate_text = nil

          # This will fail if you have a million records with the same name
          (1..999999).each do |num|
            suffix = "#{ config.separator }#{ num }"
            candidate_text = [text[0...(config.max_length - suffix.length)], suffix].join("")
            break unless obj.class.base_class.where(config.to => candidate_text).first
          end

          text = candidate_text
        end

        text
      end
    end

    included do
      def to_param
        self.public_send(self.class.base_class.acts_as_permalink_config.to)
      end

      def update_permalink
        self.public_send("#{ self.class.base_class.acts_as_permalink_config.to }=", self.class.base_class.generate_permalink_for(self))
        true
      end
    end

  end
end

ActiveRecord::Base.send(:include, Acts::Permalink)
