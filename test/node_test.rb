require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require_relative 'test_helper'

class NodeTest < Minitest::Test
  def test_node_exists
    node = Node.new('a')

    assert_instance_of Node, node
    assert_equal 'a', node.letter
    assert_equal node.children, {}
    refute node.is_word?
  end

  def test_make_word
    node = Node.new('a')
    node.make_word

    assert node.is_word?
  end


end
