module Acts
  module Permalink
    class Config
      attr_reader :to, :from, :separator, :max_length, :scope

      def initialize(options={})
        @config = options.with_indifferent_access

        @to = @config[:to].try(:to_sym) || :permalink
        @from = @config[:from].try(:to_sym) || :title
        @separator = @config[:underscore] ? "_" : "-"
        @scope = @config[:scope].presence

        @max_length = @config[:max_length].to_i rescue 0
        @max_length = 60 unless @max_length > 0
      end
    end
  end
end
