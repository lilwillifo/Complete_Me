require_relative 'node'

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



end
