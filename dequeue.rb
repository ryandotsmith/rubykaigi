require 'uri'
require 'pg'

if ARGV.length != 3
  puts "usage: ruby dequeue.rb file num_jobs num_procs"
  exit
end

DEQ_FUNC = File.read(ARGV[0])
NUM_JOBS=ARGV[1].to_i
NUM_PROCS=ARGV[2].to_i

u = ENV['DATABASE_URL'] || raise("Set DATABASE_URL")
D = URI(u)


def work
  $stdout.puts("at=fork pid=#{Process.pid}")
  n = NUM_JOBS/NUM_PROCS
  c = PG.connect(D.host, D.port, nil, nil, D.path[1..-1], D.user, D.password)
  n.times {c.exec(DEQ_FUNC)}
end

NUM_PROCS.times do
  fork {work}
end

Process.waitall
