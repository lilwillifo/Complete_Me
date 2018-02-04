# completeme class
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require_relative 'test_helper'

class CompleteMeTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
  end

  def test_complete_me_exists
    assert_instance_of CompleteMe, @completion
  end

  def test_insert
    @completion.insert('pi')
    @completion.insert('pizza')
    @completion.insert('hi')

    p_node = @completion.rootnode.children['p']

    assert @completion.rootnode.children.key?('p')
    assert_equal @completion.rootnode.children.keys, ['p', 'h']
    refute p_node.is_word?
    assert p_node.children.key?('i')
  end

  def test_insert_creates_word
    @completion.insert('pi')
    @completion.insert('pizza')
    @completion.insert('hi')

    p_node = @completion.rootnode.children['p']
    i_node = p_node.children['i']

    assert i_node.is_word?
    assert i_node.children['z'].children['z'].children['a'].is_word?
    refute i_node.children['z'].is_word?
  end

  def test_count
    assert_equal 0, @completion.count

    @completion.insert('hello')
    assert_equal 1, @completion.count

    @completion.insert('hey')
    assert_equal 2, @completion.count

    @completion.insert('PiZzA')
    assert_equal 3, @completion.count
  end

  def test_suggest
    @completion.insert('hello')
    @completion.insert('hey')
    @completion.insert('world')

    root = @completion.rootnode


    assert_equal 'o', @completion.suggest_find(%w[w o], root).letter
    assert_equal 'e', @completion.suggest_find(%w[h e], root).letter

    assert_equal @completion.suggest('he'), %w[hello hey]

    @completion.insert('he')

    assert_equal @completion.suggest('he'), %w[he hello hey]
  end

  def test_select
    @completion.insert('word')
    @completion.insert('world')
    @completion.insert('worms')
    @completion.select('wo', 'world')

    assert_equal %w[world word worms], @completion.suggest('wor')
    assert_equal %w[world word worms], @completion.suggest('wo')
    assert_equal %w[worms], @completion.suggest('worm')
  end

  def test_populate_dictionary
    skip
    dictionary = File.read('/usr/share/dict/words')
    @completion.populate(dictionary)

    assert_equal 235_886, @completion.count
  end

end
