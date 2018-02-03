require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test

  def test_complete_me_exists
    completion = CompleteMe.new
    assert_instance_of CompleteMe, completion
  end

  def test_insert
    completion = CompleteMe.new
    #refute completion.insert("pizza")
  end

  def test_insert
    completion = CompleteMe.new
    completion.insert("pi")
    completion.insert("pizza")
    completion.insert("hi")

    assert completion.rootnode.children.key?("p")
    assert_equal completion.rootnode.children.keys, ["p", "h"]
    refute completion.rootnode.children["p"].is_word?
    assert completion.rootnode.children["p"].children.key?("i")
    assert completion.rootnode.children["p"].children["i"].is_word?
    assert completion.rootnode.children["p"].children["i"].children["z"].children["z"].children["a"].is_word?
    refute completion.rootnode.children["p"].children["i"].children["z"].is_word?
  end

  def test_count
    completion = CompleteMe.new

    assert_equal 0, completion.count

    completion.insert("hello")
    assert_equal 1, completion.count

    completion.insert("hey")
    assert_equal 2, completion.count

    completion.insert("PiZzA")
    assert_equal 3, completion.count
  end

end
