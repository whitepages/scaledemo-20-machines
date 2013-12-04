require "randserver/version"
require "celluloid/autostart"
require "riemann/client"
require "logger"

module Randserver
  class Runner
    def initialize
      @client = Riemann::Client.new host: "ec2-54-203-108-168.us-west-2.compute.amazonaws.com", port: 5555, timeout: 5
      @gen = Generator.new(@client)
    end

    def run
      loop do
        @gen.fetch
        sleep 0.01
      end
    end
  end

  class Generator
    include Celluloid
    include Celluloid::Logger
    
    def initialize(client, max = 100, seed = Random.new_seed)
      @max = max
      @rand = Random.new(seed)
      @client = client
      #@stats = StatBucket.new(@client)
    end

    def fetch
      num = @rand.rand(@max)
      event = { service: "svc rand", metric: num, tags: ["value"] }
      #info event
      @client.udp << event
    end

  end
end
