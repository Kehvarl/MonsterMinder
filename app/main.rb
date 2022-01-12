class Button
  def initialize x, y, text

    @x = x
    @y = y
    @w = 5
    @h = 10
    @text = text
  end

  def render args
    @w, @h = args.gtk.calcstringbox(@text, 2)
    @w += 8
    @h += 4

    args.outputs.solids << [@x, @y, @w, @h, 128, 128, 128]
    args.outputs.borders << [@x, @y, @w, @h, 0, 0, 0]
    args.outputs.labels << [@x + (@w/2), @y + @h -2, @text, 2, 1, 0, 0, 0]
  end

  def render_pressed args
    @w, @h = args.gtk.calcstringbox(@text, 2)
    @w += 8
    @h += 4

    args.outputs.solids << [@x, @y, @w, @h, @r+128, @g+128, @b+128]
    args.outputs.borders << [@x, @y, @w, @h, 0, 0, 0]
    args.outputs.labels << [@x + (@w/2), @y + @h -2, @text, 2, 1, 0, 0, 0]
  end

  def clicked? args
    cx = args.inputs.mouse.x
    cy = args.inputs.mouse.y
    (cx >= @x and cx <= @x+@w and cy >= @y and cy <= @y+@h)
  end
end

class Monster
  def initialize x, y, type
    @x = x
    @y = y
    @type = type
    @level = 0
    @happiness = 128
    @tiredness = 0
    @sleep_time = -1
    @play = Button.new(10, y-100, "Play")
    @sleep = Button.new(70, y-100, "Sleep")

    def play
      if @tiredness < 100 and @sleep_time == -1
        @happiness += rand(10)
        @tiredness += 5
      end
    end

    def sleep
      if @sleep_time == -1
        @sleep_time = 20
      end
    end

    def render args
      x, y = @x, @y
      args.outputs.labels <<[x, y, @type]
      y -= 20
      args.outputs.labels <<[x, y, "Happiness: #{@happiness}"]
      y -= 20
      args.outputs.labels <<[x, y, "Tiredness: #{@tiredness}"]
      @play.render args
      @sleep.render args

    end

    def tick
      if @sleep_time > -1
        @sleep_time -=5
        if @sleep_time <= 0
          @tiredness = 0
          @sleep_time = -1
        end
      else
        @happiness -= rand(3)
        @tiredness += rand(2)

        if @tiredness >= 20
          sleep
        end
      end
    end
  end
end


def tick args
  args.state.monster ||= Monster.new(10, 700, "Test")
  args.state.turn_timer ||= 30

  args.state.turn_timer -= 1
  if args.state.turn_timer <= 0
    args.state.turn_timer = 30
    args.state.monster.tick
  end

  args.state.monster.render args

end

#TODO
# Monster states
# Monster transformations
# Monster Sprite Sheets
# Monster stats -> states
#   Happy
#   Normal
#   Hungry
#   Playful
# Activities to interact with monster
#   Pet
#   Feed
#   Play
#   Watch
# Theming/Skinning of application
#   Background Color
#   Background Pattern
#   Frame Color
#   Font
#   Font Color
#