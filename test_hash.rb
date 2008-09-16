require 'rubygems'
require 'test/unit'
require 'new_hash'

class TestHash < Test::Unit::TestCase
  def test_with_method_returns_clone_with_additional_element
    foo = {:a => 'a', :b => 'b'}
    assert_equal({:a=>'a', :b=>'b', :c=>'c'}, foo.with(:c, 'c'))
  end
end
