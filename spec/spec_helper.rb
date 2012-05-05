require 'rails'
require 'active_record'
require 'active_support'
require 'acts_as_permalink'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  # config.filter_run :focus
end


## Manually setup the Active Record DB stuff and a test model

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "#{File.expand_path(File.join(File.dirname(__FILE__), '..'))}/spec/db/test.sqlite3"
)

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'posts'")
ActiveRecord::Base.connection.create_table(:posts) do |t|
  t.string :title
  t.string :permalink
  t.string :other_title
  t.string :other_permalink
end
