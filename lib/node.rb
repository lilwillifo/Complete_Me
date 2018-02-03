class Node
  attr_reader :letter,
              :children

  def initialize(letter)
    @letter = letter
    @children = {}
    @word = false
  end

  def make_word
    @word = true
  end

  def is_word?
    @word
  end


end
