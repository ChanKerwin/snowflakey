require "securerandom"
require "snowflake/version"

class Snowflake
  BASE = 36

  def initialize(prefix, size, time, id, base)
    @prefix = prefix
    @size   = size
    @time   = time
    @id     = id
    @base   = base
  end

  attr_reader :prefix, :size, :time, :id, :base

  class << self
    def generate(prefix: nil, size: 96, time: Time.now, base: BASE)
      r = (SecureRandom.random_number * 1e16).round

      new(prefix, size, time.utc, r, base)
    end

    def verify(snowflake, size: 96, base: BASE)
      id, prefix = snowflake.reverse.split("_", 2).map { |s| s.reverse }
      ms         = id.to_i(base) >> (size - 41)
      time       = Time.at((ms / 1e3)).utc
      id         = id.to_i(base) % (2 ** (size - 41))

      new(prefix, size, time, id, base)
    end
  end

  def to_s
    t  = (@time.to_f * 1e3).round
    id = t << (@size - 41)
    id = id | @id % (2 ** (@size - 41))
    id = id.to_s(@base)

    [*@prefix, id].compact.join("_")
  end

  def inspect
    to_s
  end
end
