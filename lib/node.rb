
class Node
  attr_reader :letter,
              :children

  def initialize(letter)
    @letter = letter
    @children = {}
    @word = false
    @selections = []
  end

  def make_word
    if @word == false
      @word = true
    else
      'That word is already in the dictionary.'
    end
  end

  def delete_word
    if @word == true
      @word = false
      true
    else
      false
    end
  end

  def is_word?
    @word
  end

  def add_select(word)
    inserted = false
    index = 0
    while !inserted && index < @selections.length
      if @selections[index][0] == word
        inserted = true
        @selections[index][1] += 1
        swap_sort(index)
      else
        i += 1
      end
    end
    @selections << [word, 1] unless inserted
  end

  def swap_sort(index)
    while @selections[index - 1][1] < @selections[i][1]
      swap = @selections[index - 1]
      @selections[index - 1] = @selections[i]
      @selections[index] = swap
    end
  end

  def retrieve_selections
    @selections.map { |selection| selection[0] }
  end
end
