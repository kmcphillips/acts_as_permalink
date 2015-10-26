# ActsAsPermalink
module Acts #:nodoc:
  module Permalink #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_permalink(options={})
        # Read and scrub option for the column which will save the permalink
        self.base_class.instance_variable_set('@permalink_column_name', options[:to].try(:to_sym) || :permalink)

        # Read and scrub the option for the column or function which will generate the permalink
        self.base_class.instance_variable_set('@permalink_source', (options[:from].try(:to_sym) || :title))

        # Set the underscore character
        self.base_class.instance_variable_set('@permalink_underscore', options[:underscore])

        # Read and validate the maximum length of the permalink
        max_length = options[:max_length].to_i rescue 0
        max_length = 60 unless max_length && max_length > 0
        self.base_class.instance_variable_set('@permalink_length', max_length)

        if Rails.version >= "3"
          before_validation :update_permalink, on: :create
        else
          before_validation_on_create :update_permalink
        end

        validates_uniqueness_of @permalink_column_name
        attr_readonly @permalink_column_name

        include Acts::Permalink::InstanceMethods
        extend Acts::Permalink::SingletonMethods
      end

      # Returns the unique permalink string for the passed in object.
      def generate_permalink_for(obj)
        column_name = obj.class.base_class.instance_variable_get('@permalink_column_name')
        text = obj.send(obj.class.base_class.instance_variable_get('@permalink_source'))
        max_length = obj.class.base_class.instance_variable_get('@permalink_length')
        separator = obj.class.base_class.instance_variable_get('@permalink_underscore') ? "_" : "-"

        # If it is blank then generate a random link
        if text.blank?
          text = obj.class.base_class.to_s.downcase + rand(10000).to_s

        # If it is not blank, scrub
        else
          text = text.downcase.strip                  # make the string lowercase and scrub white space on either side
          text = text.gsub(/[^a-z0-9\w]/, separator)  # make any character that is not nupermic or alphabetic into a special character
          text = text.squeeze(separator)              # removes any consecutive duplicates of the special character
          text = text[0...max_length]                 # trim to length
          text = text.sub(Regexp.new("^#{ separator }+"), "")  # remove leading special characters
          text = text.sub(Regexp.new("#{ separator }+$"), "")  # remove trailing special characters
        end

        # Attempt to find the object by the permalink, and if so there is a collision and we need to de-collision it
        if obj.class.base_class.where(column_name => text).first
          candidate_text = nil

          (1..999999).each do |num|
            suffix = "#{ separator }#{ num }"
            candidate_text = [text[0...(max_length - suffix.length)], suffix].join("")
            break unless obj.class.base_class.where(column_name => candidate_text).first
          end

          text = candidate_text
        end

        text
      end
    end

    module SingletonMethods
    end

    module InstanceMethods

      # Override this method so that find searches by permalink and not by id
      def to_param
        self.send(self.class.base_class.instance_variable_get('@permalink_column_name'))
      end

      # Generate the permalink and assign it directly via callback
      def update_permalink
        self.send("#{ self.class.base_class.instance_variable_get('@permalink_column_name') }=", self.class.base_class.generate_permalink_for(self))
        true
      end
    end
  end
end

ActiveRecord::Base.send(:include, Acts::Permalink)
