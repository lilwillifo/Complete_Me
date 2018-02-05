require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require_relative 'test_helper'

# test for complete me class
class CompleteMeTest < Minitest::Test
  def setup
    @completion = CompleteMe.new
  end

  def test_complete_me_exists
    assert_instance_of CompleteMe, @completion
  end

  def test_insert
    @completion.insert('pi')
    @completion.insert('hi')

    assert @completion.rootnode.children.key?('p')
    assert @completion.rootnode.children.key?('h')
  end

  def test_insert_array
    @completion.insert('pi')
    @completion.insert('hi')

    p_node = @completion.rootnode.children['p']

    assert_equal @completion.rootnode.children.keys, %w[p h]
    refute p_node.is_word?
    assert p_node.children.key?('i')
  end

  def test_insert_creates_word
    @completion.insert('pi')
    @completion.insert('pie')

    i_node = @completion.rootnode.children['p'].children['i']

    assert i_node.is_word?
    assert i_node.children['e'].is_word?
  end

  def test_substrings_arent_words
    @completion.insert('hello')

    refute @completion.rootnode.children['h'].is_word?
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

    assert_equal 'o', @completion.find_substring_node(%w[w o], root).letter
    assert_equal 'e', @completion.find_substring_node(%w[h e], root).letter

    assert_equal @completion.suggest('he'), %w[hello hey]

    @completion.insert('he')

    assert_equal @completion.suggest('he'), %w[he hello hey]
  end

  def test_select
    @completion.insert('word')
    @completion.insert('world')
    @completion.insert('worms')
    @completion.select('wo', 'world')

    assert_equal %w[word world worms], @completion.suggest('wor')
    assert_equal %w[world word worms], @completion.suggest('wo')
    assert_equal %w[worms], @completion.suggest('worm')
  end

  def test_populate_dictionary
    dictionary = File.read('/usr/share/dict/words')
    @completion.populate(dictionary)

    assert_equal 235_886, @completion.count
  end
end
