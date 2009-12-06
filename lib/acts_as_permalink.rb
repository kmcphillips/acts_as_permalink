# ActsAsPermalink
module Acts #:nodoc:
  module Permalink #:nodoc:

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def acts_as_permalink(options={})
        before_validation_on_create :update_permalink
        validates_uniqueness_of :permalink
        attr_readonly :permalink
        
        include Acts::Permalink::InstanceMethods
        extend Acts::Permalink::SingletonMethods
      end
      
      def generate_permalink_for(obj, text)
        text = text.downcase.strip.gsub(/[^a-z0-9\w]/, "_").sub(/_+$/, "").sub(/^_+/, "")[0..60]
        
        if text.blank?
          text = obj.class.to_s.downcase + rand(10000)
        end
        
        if obj.class.find_by_permalink(text)
          num = 1

          while obj.class.find_by_permalink(text + num.to_s)
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
      def to_param
        permalink
      end
      
      def update_permalink
        self.permalink = self.class.generate_permalink_for(self, self.title)
      end
    end
  end
end
