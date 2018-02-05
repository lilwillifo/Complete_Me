require_relative 'node'
require 'pry'

class CompleteMe
  attr_reader :rootnode

  def initialize
    @rootnode = Node.new('')
    @totalwords = 0
  end

  def insert(word)
    @totalwords += 1
    letters = word.downcase.chars
    insert_helper(letters, @rootnode)
  end

  def insert_helper(letters, node)
    if !letters.empty?
      go_to_next_letter(letters, node)
    else
      node.make_word
    end
  end

  def go_to_next_letter(letters, node)
    if node.children.key?(letters[0])
      next_node = node.children[letters[0]]
      letters.delete_at(0)
      insert_helper(letters, next_node)
    else
      new_node = Node.new(letters[0])
      node.children[letters[0]] = new_node
      letters.delete_at(0)
      insert_helper(letters, new_node)
    end
  end

  def count
    @totalwords
  end

  def suggest(substring)
    letters = substring.downcase.chars
    sub_node = find_substring_node(letters, @rootnode)
    (sub_node.retrieve_selections + suggest_array(sub_node, substring)).uniq
  end

  def find_substring_node(letters, node)
    if !letters.empty?
      if node.children.key?(letters[0])
        next_node = node.children[letters[0]]
        letters.delete_at(0)
        find_substring_node(letters, next_node)
      end
    else
      node
    end
  end

  def suggest_array(node, substring)
    suggestions = []
    suggestions << substring if node.is_word?
    node.children.each do |letter, letter_node|
      suggestions += suggest_array(letter_node, substring + letter)
    end
    suggestions
  end

  def select(substring, selection)
    letters = substring.downcase.chars
    sub_node = find_substring_node(letters, @rootnode)
    sub_node.add_select(selection.downcase)
  end

  def populate(dictionary)
    words = dictionary.split
    words.each do |word|
      insert(word)
    end
  end

  def delete(word)

  end
end
