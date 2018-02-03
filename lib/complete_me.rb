require_relative 'node'

class CompleteMe

  attr_reader :rootnode

  def initialize
    @rootnode = Node.new("")
  end

  def insert(word)
    letters = word.chars
    insert_helper(letters, @rootnode)
  end

  def insert_helper(letters, node)
    while letters.length > 1 do
      if node.children.key?(letters[0])

      else
        new_node = Node.new(letters[0])
        node.children[letters[0]] = new_node
        letters.delete_at(0)
        insert_helper(letters,new_node)
      end
    end

  end



end
