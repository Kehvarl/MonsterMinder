class Monster
  def initialize type
    @type = type
    @level = 0
    @happiness = 128
    @tiredness = 0
    @sleep_time = -1

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
      x = 0
      y = 700
      args.outputs.labels <<[x, y, @type]
      args.outputs.labels <<[x, y - 20, "Happiness: #{@happiness}"]
      args.outputs.labels <<[x, y - 40, "Tiredness: #{@tiredness}"]

      w,h = args.gtk.calcstringbox("Play", 1)
      args.outputs.borders << [x, y - 60 - h, w, h, 0, 0, 0]
      args.outputs.labels << [x + (w/2), y - 60 - h + h -2, "Play", 1, 1]

      w,h = args.gtk.calcstringbox("Sleep", 1)
      args.outputs.borders << [x + w + 5, y - 60 - h, w, h, 0, 0, 0]
      args.outputs.labels << [x + w + 5 + (w/2), y - 60 - h + h -2, "Sleep", 1, 1]

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

class Button
  def initialize x, y, r, g, b, text, tr, tg, tb, args

    @x = x
    @y = y
    @w, @h = args.gtk.calcstringbox(text, 2)
    @w += 8
    @h += 4
    @r = r
    @g = g
    @b = b
    @text = text
    @tr = tr
    @tg = tg
    @tb = tb
  end

  def render args
    args.outputs.solids << [@x, @y, @w, @h, @r, @g, @b]
    args.outputs.borders << [@x, @y, @w, @h, 0, 0, 0]
    args.outputs.labels << [@x + (@w/2), @y + @h -2, @text, 2, 1, @tr, @tg, @tb]
  end

  def render_pressed args
    args.outputs.solids << [@x, @y, @w, @h, @r+128, @g+128, @b+128]
    args.outputs.borders << [@x, @y, @w, @h, 0, 0, 0]
    args.outputs.labels << [@x + (@w/2), @y + @h -2, @text, 2, 1, @tr, @tg, @tb]
  end

  def clicked? args
    cx = args.inputs.mouse.x
    cy = args.inputs.mouse.y
    (cx >= @x and cx <= @x+@w and cy >= @y and cy <= @y+@h)
  end

end

def tick args
  args.state.monster ||= Monster.new("Test")
  args.state.button ||= Button.new(128, 64, 128, 128, 128, "Test", 0, 0, 0, args)
  args.state.turn_timer ||= 30

  args.state.turn_timer -= 1
  if args.state.turn_timer <= 0
    args.state.turn_timer = 30
    args.state.monster.tick
  end

  args.state.monster.render args
  args.state.button.render args

  if args.inputs.mouse.click or args.inputs.mouse.down

    if args.state.button.clicked? args
      args.state.monster.play
      args.state.button.render_pressed args
    end
  end
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