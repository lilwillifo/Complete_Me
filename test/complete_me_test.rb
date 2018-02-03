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
    completion.insert("pizza")

    assert completion.rootnode.children.key?("p")
  end

end
