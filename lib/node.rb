
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
    i = 0
    while !inserted && i < @selections.length
      if @selections[i][0] == word
        inserted = true
        @selections[i][1] += 1
        swap_sort(index)
      else
        i += 1
      end
    end
    @selections << [word, 1] unless inserted
  end

  def swap_sort(index)
    while @selections[i - 1][1] < @selections[i][1]
      swap = @selections[i - 1]
      @selections[i - 1] = @selections[i]
      @selections[i] = swap
    end
  end

  def retrieve_selections
    @selections.map { |selection| selection[0] }
  end
end
