require "time"
require "securerandom"
require "baseconv"
require "snowflakey/snowflake"
require "snowflakey/version"

module Snowflakey
  module_function

  def generate(prefix = nil, size: 96, time: Time.now, base: Snowflake::BASE)
    r = (SecureRandom.random_number * 1e16).round

    Snowflake.new(prefix, size, time.utc, r, base).to_s
  end

  def verify(snowflake, size: 96, base: Snowflake::BASE)
    id, prefix = snowflake.reverse.split("_", 2).map { |s| s.reverse }
    ms         = id.to_i(base) >> (size - 41)
    time       = Time.at((ms / 1e3)).utc
    id         = Baseconv.convert(id, from_base: base.to_i, to_base: 10)
    id         = id.to_i % (2 ** (size - 41))

    Snowflake.new(prefix, size, time, id, base)
  end
end
