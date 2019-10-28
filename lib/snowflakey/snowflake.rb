module Snowflakey
  class Snowflake
    BASE = 36

    def initialize(prefix, size, time, id, base)
      @prefix = prefix
      @size   = size
      @time   = time
      @id     = id
      @base   = base.to_i
    end

    attr_reader :prefix, :size, :time, :id, :base

    def to_s
      t  = (@time.to_f * 1e3).round
      id = t << (@size - 41)
      id = id | @id % (2 ** (@size - 41))
      id = Baseconv.convert(id, from_base: 10, to_base: @base)

      [*@prefix, id].compact.join("_")
    end

    def inspect
      to_s
    end
  end
end
