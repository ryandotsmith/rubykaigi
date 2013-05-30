require 'uri'
require 'pg'

u = ENV['DATABASE_URL'] || raise("Set DATABASE_URL")
D = URI(u)

NUM_JOBS = ARGV[0].to_i

puts("Establishing connection.")
c = PG.connect(D.host, D.port, nil, nil, D.path[1..-1], D.user, D.password)

puts("Creating table.")
c.exec("drop table if exists jobs cascade")
c.exec("create table jobs (id serial, q_name text, locked_at timestamptz)")

puts("Adding lock-head function.")
c.exec(File.read('lock-head.sql'))

c.exec("begin")
puts("Inserting #{NUM_JOBS} jobs.")
NUM_JOBS.times do
  c.exec("insert into jobs (locked_at) values (null)")
end
c.exec("COMMIT")
puts c.exec("select count(*) from jobs")[0]
puts("Finished.")

