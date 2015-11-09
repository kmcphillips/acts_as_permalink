database_file = "#{ File.expand_path(File.join(File.dirname(__FILE__), '..')) }/db/test.sqlite3"
FileUtils.rm(database_file) if File.exists?(database_file)

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: database_file
)

connection = ActiveRecord::Base.connection

connection.create_table(:posts) do |t|
  t.string :title
  t.string :permalink
  t.string :other_title
  t.string :other_permalink
end

connection.create_table(:things) do |t|
  t.string :title
  t.string :permalink
  t.string :type
end

connection.create_table(:long_things) do |t|
  t.string :title
  t.string :permalink
  t.string :type
end

connection.create_table(:normal_things) do |t|
  t.string :title
end

connection.create_table(:events) do |t|
  t.string :title
  t.string :permalink
  t.string :description
  t.integer :owner_id
end
