# ActsAsPermalink
module Acts #:nodoc:
  module Permalink #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_permalink(options={})
        # Read and scrub option for the column which will save the permalink    
        permalink_column_name = options[:to].try(:to_sym) || :permalink
        write_inheritable_attribute :permalink_column_name, permalink_column_name
        class_inheritable_reader    :permalink_column_name

        # Read and scrub the option for the column or function which will generate the permalink 
        write_inheritable_attribute :permalink_source, (options[:from].try(:to_sym) || :title)
        class_inheritable_reader    :permalink_source

        # Read and validate the maximum length of the permalink
        max_length = options[:max_length].to_i rescue 0
        max_length = 60 unless max_length && max_length > 0
        write_inheritable_attribute :permalink_length, max_length
        class_inheritable_reader    :permalink_length

        if Rails.version >= "3"
          before_validation :update_permalink, :on => :create
        else
          before_validation_on_create :update_permalink
        end

        validates_uniqueness_of permalink_column_name
        attr_readonly permalink_column_name
        
        include Acts::Permalink::InstanceMethods
        extend Acts::Permalink::SingletonMethods
      end
      
      # Returns the unique permalink string for the passed in object.
      def generate_permalink_for(obj)
        # Find the source for the permalink
        text = obj.send(obj.permalink_source)
        
        # If it is blank then generate a random link
        if text.blank?
          text = obj.class.to_s.downcase + rand(10000).to_s

        # If it is not blank, scrub
        else
          text = text.downcase.strip                  # make the string lowercase and scrub white space on either side
          text = text.gsub(/[^a-z0-9\w]/, "_")        # make any character that is not nupermic or alphabetic into an underscore
          text = text.sub(/_+$/, "").sub(/^_+/, "")   # remove underscores on either end, caused by non-simplified characters
          text = text[0..obj.permalink_length]        # trim to length
        end
        
        # Attempt to find the object by the permalink
        if obj.class.base_class.send("find_by_#{obj.permalink_column_name}", text)
          num = 1

          # If we find the object we know there is a collision, so just add a number to the end until there is no collision
          while obj.class.base_class.send("find_by_#{obj.permalink_column_name}", text + num.to_s)
            num += 1
          end

          text = text + num.to_s
        end
        text
      end
    end
  
    module SingletonMethods
    end
    
    module InstanceMethods

      # Override this method so that find searches by permalink and not by id
      def to_param
        self.send(self.permalink_column_name)
      end
      
      # Generate the permalink and assign it directly via callback
      def update_permalink
        self.send("#{self.permalink_column_name}=", self.class.generate_permalink_for(self))
      end
    end
  end
end
