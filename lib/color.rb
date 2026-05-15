# frozen_string_literal: true

def set_color(index, content, weight = 0)
  "\e[#{weight};#{index}m#{content}\e[0m "
end
