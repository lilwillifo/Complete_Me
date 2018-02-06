require_relative 'node'
require 'pry'

# class for autocomplete
class CompleteMe
  attr_reader :rootnode

  def initialize
    @rootnode = Node.new('')
    @totalwords = 0
    @dictionary = []
  end

  def insert(word)
    @totalwords += 1
    @dictionary << word
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

  def suggest_substring(substring)
    all_words = @dictionary.find_all do |word|
      word.include?(substring)
    end
    suggestions = all_words.each do |word|
      suggest(word) unless word == substring
    end
    (suggest(substring) + suggestions).uniq
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
    suggestions << substring if node.word?
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
    @dictionary.delete(word)
    letters = word.downcase.chars
    parents = find_parents(letters, @rootnode)
    parent = parents[-1]
    delete_helper(parent, parents, word) unless parent == @rootnode
  end

  def delete_helper(parent, parents, word)
    if !parent.children.empty?
      parent.delete_word
      remove_suggestions(parents, word.downcase)
    else
      node_array = delete_with_no_children(word.downcase.chars, parents)
      remove_suggestions(node_array, word.downcase)
    end
  end

  def delete_with_no_children(letters, parents)
    parents.pop
    parent = parents[-1]
    parent.children.delete(letters.pop)
    if parent.children.empty? && !parent.word? && parent != @rootnode
      delete_with_no_children(letters, parents)
    end
    parents
  end

  def remove_suggestions(node_array, word)
    node_array.each do |node|
      node.delete_selection(word)
    end
  end

  def find_parents(letters, node)
    parents = [node]
    unless letters.empty?
      if node.children.key?(letters[0])
        next_node = node.children[letters[0]]
        letters.delete_at(0)
        parents += find_parents(letters, next_node)
      else parents
      end
    end
    parents
  end
end
