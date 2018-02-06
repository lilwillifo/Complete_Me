require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'
require_relative 'test_helper'
require 'pry'

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

    root = @completion.rootnode

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
    skip
    dictionary = File.read('/usr/share/dict/words')
    @completion.populate(dictionary)

    assert_equal 235_886, @completion.count
  end

  def test_populate_denver_addresses
    skip
    dictionary = File.readlines('./test/addresses.csv')
    dictionary.delete_at(0)
    dictionary.each do |line|
      @completion.insert(line.split(',')[-1].chomp)
    end

    expected = ['4900 n dahlia st', '4900 n durham ct', '4900 n duluth ct',
                '4900 n decatur st', '4900 n dillon st']

    assert_equal 310_015, @completion.count
    assert_equal ['4900 n dahlia st'], @completion.suggest('4900 n da')
    assert_equal expected, @completion.suggest('4900 n d')
  end

  def test_delete_if_word_doesnt_exist
    assert_nil @completion.delete('anything')
  end

  def test_delete_of_word_with_children
    @completion.insert('hi')
    @completion.insert('him')
    @completion.delete('hi')

    assert_equal ['h'], @completion.rootnode.children.keys
    refute @completion.rootnode.children['h'].children['i'].is_word?
  end

  def test_delete_of_word_with_no_children
    @completion.insert('hi')
    @completion.insert('him')
    @completion.delete('him')

    i_node = @completion.rootnode.children['h'].children['i']

    assert i_node.is_word?
    refute i_node.children.keys.include?('m')
  end

  def test_delete_word_with_parent_word_steps_back
    @completion.insert('hi')
    @completion.insert('hide')
    @completion.delete('hide')

    i_node = @completion.rootnode.children['h'].children['i']

    assert i_node.is_word?
    refute i_node.children.keys.include?('d')
  end

  def test_delete_only_word_in_tree
    @completion.insert('word')
    @completion.delete('word')

    assert_equal 0, @completion.rootnode.children.length
  end

  def test_remove_suggestions
    @completion.insert('a')
    @completion.insert('at')

    @completion.select('a', 'at')

    assert_equal %w[at a], @completion.suggest('a')

    @completion.delete('at')

    assert_equal ['a'], @completion.suggest('a')
  end

  def test_suggest_substring
    @completion.insert('complete')
    @completion.insert('incomplete')
    @completion.insert('copter')

    assert_equal %w[complete incomplete], @completion.suggest_substring('com')

    @completion.select('com', 'incomplete')

    assert_equal %w[incomplete complete], @completion.suggest_substring('com')
  end
end
