module Acts
  module Permalink
    extend ActiveSupport::Concern

    class_methods do
      def acts_as_permalink(options={})
        cattr_accessor :acts_as_permalink_config
        self.acts_as_permalink_config = Acts::Permalink::Config.new(options)

        before_validation :update_permalink, on: :create

        unless self.acts_as_permalink_config.allow_update
          attr_readonly self.acts_as_permalink_config.to
        end

        if self.acts_as_permalink_config.scope
          validates self.acts_as_permalink_config.to, uniqueness: {scope: self.acts_as_permalink_config.scope}
        else
          validates self.acts_as_permalink_config.to, uniqueness: true
        end


        include Acts::Permalink::InstanceMethods
      end
    end

    module InstanceMethods
      def to_param
        self.public_send(self.class.base_class.acts_as_permalink_config.to)
      end

      def update_permalink
        self.public_send("#{ self.class.base_class.acts_as_permalink_config.to }=", build_permalink)
        true
      end

      def build_permalink
        config = self.class.base_class.acts_as_permalink_config

        text = self.public_send(config.from)
        text = [self.class.base_class.to_s, rand(10000)].join(config.separator) if text.blank?
        text = text.to_permalink(separator: config.separator, max_length: config.max_length)

        # scope it if one is present
        conditions = {}
        conditions[config.scope] = self.public_send(config.scope) if config.scope.present?

        # Attempt to find the object by the permalink, and if so there is a collision and we need to de-collision it
        if self.class.base_class.where(conditions.merge(config.to => text)).any?
          candidate_text = nil

          # This will fail if you have a million records with the same name
          (1..999999).each do |num|
            suffix = "#{ config.separator }#{ num }"
            candidate_text = [text[0...(config.max_length - suffix.length)], suffix].join("")
            break unless self.class.base_class.where(conditions.merge(config.to => candidate_text)).any?
          end

          text = candidate_text
        end

        text
      end
    end

  end
end
