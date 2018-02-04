require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'
require_relative 'test_helper'

# test of Node class
class NodeTest < Minitest::Test
  def test_node_exists
    node = Node.new('a')

    assert_instance_of Node, node
    assert_equal 'a', node.letter
    assert_equal node.children, {}
    refute node.is_word?
  end

  def test_is_not_word_by_default
    node = Node.new('a')

    refute node.is_word?
  end

  def test_make_word
    node = Node.new('a')
    node.make_word

    assert node.is_word?
  end

  def test_delete_word
    node = Node.new('a')
    node.make_word
    node.delete_word

    refute node.is_word?
  end

  def test_select_and_retrieve_selections
    node = Node.new('a')

    node.add_select('alpha')

    assert_equal ['alpha'], node.retrieve_selections

    node.add_select('alpha')

    assert_equal ['alpha'], node.retrieve_selections

    node.add_select('apple')
    node.add_select('apple')

    assert_equal %w[alpha apple], node.retrieve_selections

    node.add_select('apple')

    assert_equal %w[apple alpha], node.retrieve_selections
  end
end
