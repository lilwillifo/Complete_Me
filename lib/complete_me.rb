require_relative 'node'
require 'pry'

class CompleteMe
  attr_reader :rootnode

  def initialize
    @rootnode = Node.new("")
    @totalwords = 0
  end

  def insert(word)
    @totalwords += 1
    letters = word.downcase.chars
    insert_helper(letters, @rootnode)
  end

  def insert_helper(letters, node)
    if letters.length > 0
      if node.children.key?(letters[0])
        next_node = node.children[letters[0]]
        letters.delete_at(0)
        insert_helper(letters, next_node)
      else
        new_node = Node.new(letters[0])
        node.children[letters[0]] = new_node
        letters.delete_at(0)
        insert_helper(letters,new_node)
      end
    else
      node.make_word
    end
  end

  def count
    @totalwords
  end

  def suggest(substring)
    letters = substring.downcase.chars
    sub_node = find_substring_node(letters, @rootnode)
    (sub_node.get_selections+suggest_array(sub_node, substring)).uniq
  end

  def find_substring_node(letters, node)
    if letters.length > 0
      if node.children.key?(letters[0])
        next_node = node.children[letters[0]]
        letters.delete_at(0)
        find_substring_node(letters, next_node)
      else #does not exist
        nil
      end
    else
      node
    end
  end

  def suggest_array(node, substring)
    suggestions = []
    if node.is_word?
      suggestions << substring
    end
    node.children.each do |letter, lnode|
      suggestions += suggest_array(lnode, substring + letter)
    end
    suggestions
  end

  def select(substring, selection)
    letters = substring.downcase.chars
    sub_node = find_substring_node(letters, @rootnode)
    sub_node.add_select(selection.downcase)
  end

  def populate(dictionary)
  end

end
