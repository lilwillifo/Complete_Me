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
    letters = word.downcase.chars
    parent_array = delete_helper_find(letters, @rootnode)
    if parent_array[-1] == "Does not exist"
      "Does not exist"
    elsif !parent_array[-1].children.empty?#word has children
      parent_array[-1].delete_word
      remove_suggestions(parent_array, word.downcase)
    else
      node_array = delete_helper(word.downcase.chars, parent_array)
      remove_suggestions(node_array, word.downcase)
    end
  end

  def delete_helper(letters, parent_array)
    parent_array.pop
    parent_array[-1].children.delete(letters.pop)
    if parent_array[-1].children.empty? && !parent_array[-1].is_word? && parent_array[-1] != @rootnode#word has no children and node is not a word
      delete_helper(letters, parent_array)
    end
    parent_array
  end

  def remove_suggestions(node_array, word)
    node_array.each do |node|
      node.delete_selection(word)
    end
  end

  def delete_helper_find(letters, node)
    parent_array = [node]
    if !letters.empty?
      if node.children.key?(letters[0])
        next_node = node.children[letters[0]]
        letters.delete_at(0)
        parent_array += delete_helper_find(letters, next_node)
      else
        parent_array << "Does not exist"
      end
    end
    parent_array
  end
end
