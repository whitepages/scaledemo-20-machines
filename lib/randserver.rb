require "randserver/version"
require "celluloid/autostart"
require "riemann/client"
require "random"

module Randserver
  class Runner
    def initialize
      @client = Riemann::Client.new host: localhost, port: 5555, timeout: 5
      @gen = Generator.new(@client)
    end

    def run
      loop do
        @gen.async.fetch
      end
    end
  end

  class Generator
    include Celluloid
    
    def initialize(client, max = 100, seed = Random.new_seed)
      @max = max
      @rand = Random.new(seed)
      @client = client
      @stats = StatBucket.new(@client)
    end

    def fetch
      num = @rand.rand(@max)
      stats.async.store(num)
      client << { service: "svc.rand.value", metric: num }
    end

  end

  class StatBucket
    include Celluloid
    exclusive :collect, :store

    def initialize(client)
      @values = []
      @timer = after(10) { collect }
      @client = client
    end

    def store(num)
      @values << num
    end

    def collect
      count = @values.length
      avg = @values.inject { | sum, el | sum + el }.to_f / count
      @values = []
      self.async.report(count, avg)
    end

    def report(count, avg)
      @client << { service: "svc.rand.stat.rps", metric: count.to_f / 10 }
      @client << { service: "svc.rand.stat.avg", metric: avg, state: avg > 40 ? "ok" : "warn" }
    end

  end
end
