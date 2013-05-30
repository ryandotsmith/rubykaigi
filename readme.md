#rubykaigi database benchmark

This is code used to demonstrate the performance impact of locking algorithms.

## Usage

With Locks:
```bash
$ export DATABASE_URL=postgres://localhost:5432/your-db
$ ruby seed.rb 10000
$ time ruby dequeue.rb lock.sql 10000 10
```

Without Locks:
```bash
$ export DATABASE_URL=postgres://localhost:5432/your-db
$ ruby seed.rb 10000
$ time ruby dequeue.rb lock-free.sql 10000 10
```
