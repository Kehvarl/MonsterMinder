class Monster
  def initialize x, y
    @sprites = ['sprites/circle/red.png', 'sprites/circle/orange.png', 'sprites/circle/yellow.png',
                'sprites/circle/green.png', 'sprites/circle/blue.png', 'sprites/circle/indigo.png',
                'sprites/circle/violet.png', 'sprites/hexagon/indigo.png', 'sprites/hexagon/blue.png']
    @current = 0
    @x = x
    @y = y
    @size = 16

    def sprite
      @sprites[@current]
    end
  end

  def click
    @size += 1
    if rand(10) >= 9
      @current += 1
    end
  end

  def tick args
    args.outputs.sprites << [@x, @y, @size, @size, sprite]
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
  args.state.monster ||= Monster.new(64, 64)
  args.state.button ||= Button.new(128, 64, 128, 128, 128, "Test", 0, 0, 0, args)

  args.state.monster.tick args
  args.state.button.render args

  if args.inputs.mouse.click or args.inputs.mouse.down

    if args.state.button.clicked? args
      args.state.monster.click
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