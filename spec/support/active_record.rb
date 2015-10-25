ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "#{ File.expand_path(File.join(File.dirname(__FILE__), '..')) }/db/test.sqlite3"
)

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'posts'")
ActiveRecord::Base.connection.create_table(:posts) do |t|
  t.string :title
  t.string :permalink
  t.string :other_title
  t.string :other_permalink
end

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'things'")
ActiveRecord::Base.connection.create_table(:things) do |t|
  t.string :title
  t.string :permalink
  t.string :type
end
