require 'test_helper'

class SnowflakeTest < Minitest::Test
  def setup
    @time      = Time.parse("2016-12-04T22:22:22Z").utc
    @snowflake = Snowflake.new("snow", 96, @time, 3104654282887302, 36)
  end

  def test_that_it_has_a_version_number
    refute_nil Snowflake::VERSION
  end

  def test_that_we_can_haz_a_snowflake
    assert @snowflake
    assert_instance_of Snowflake, @snowflake
    assert_equal "snow", @snowflake.prefix
    assert_equal 96, @snowflake.size
    assert_equal @time, @snowflake.time
    assert_equal 3104654282887302, @snowflake.id
    assert_equal 36, @snowflake.base
    assert_equal "snow_567z7pfvdq47fswkt52", @snowflake.to_s
  end

  def test_that_we_can_verify_a_snowflake
    snowflake = Snowflake.verify(@snowflake.to_s)

    assert snowflake
    assert_instance_of Snowflake, snowflake
    assert_equal @snowflake.prefix, snowflake.prefix
    assert_equal @snowflake.size, snowflake.size
    assert_equal @snowflake.time, snowflake.time
    assert_equal @snowflake.id, snowflake.id
    assert_equal @snowflake.base, snowflake.base
    assert_equal @snowflake.to_s, snowflake.to_s
  end

  def test_that_we_can_generate_a_snowflake
    assert_match %r/^[0-9a-z]+$/, Snowflake.generate
  end

  def test_that_we_can_generate_longer_snowflakes
    assert_equal 19, Snowflake.generate.size
    assert_equal 25, Snowflake.generate(size: 128).size
  end

  def test_that_we_can_generate_snowflake_in_another_base
    assert_match %r/^[0-9]+$/, Snowflake.generate(base: 10)
  end

  def test_that_we_can_generate_a_snowflake_with_a_prefix
    assert_match %r/^snow_[0-9a-z]+$/, Snowflake.generate("snow")
  end

  def test_that_we_can_generate_a_snowflake_with_a_multiple_prefixes
    assert_match %r/^snow_flake_[0-9a-z]+$/, Snowflake.generate(["snow", "flake"])
  end
end
