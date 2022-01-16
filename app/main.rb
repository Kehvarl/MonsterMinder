class Button
  def initialize x, y, text
    @x = x
    @y = y
    @w = 5
    @h = 10
    @text = text
    @clicked = false
  end

  def render args
    if @clicked
      render_pressed args
      @clicked = false
    else
      render_normal args
    end
  end

  def render_normal args
    w, h = args.gtk.calcstringbox(@text, 2)
    w += 8
    h += 4
    args.outputs[:scene].w = w
    args.outputs[:scene].h = h

    # make the background transparent
    args.outputs[:scene].background_color = [255, 255, 255, 0]

    # set the blendmode of the label to 0 (no blending)
    # center it inside of the scene
    # set the vertical_alignment_enum to 1 (center)
    args.outputs[:scene].labels  << { x: 0,
                                      y: 15,
                                      text: @text,
                                      blendmode_enum: 0,
                                      vertical_alignment_enum: 1 }

    # add a border to the render target
    args.outputs[:scene].borders << { x: 0,
                                      y: 0,
                                      w: args.outputs[:scene].w,
                                      h: args.outputs[:scene].h }

    # add the rendertarget to the main output as a sprite
    args.outputs.sprites << { x: @x,
                              y: @y,
                              w: args.outputs[:scene].w,
                              h: args.outputs[:scene].h,
                              path: :scene }

  end

  def render_pressed args
    @w, @h = args.gtk.calcstringbox(@text, 2)
    @w += 8
    @h += 4

    args.outputs.solids << [@x, @y, @w, @h, 255, 255, 255]
    args.outputs.borders << [@x, @y, @w, @h, 0, 0, 0]
    args.outputs.labels << [@x + (@w/2), @y + @h -2, @text, 2, 1, 0, 0, 0]
  end

  def click args
    if args.inputs.mouse.button_left
      @clicked =  clicked?(args)
    end
    return @clicked
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
    @ticks = 100
    @play = Button.new(@x + 10, y-100, "Play")
    @sleep = Button.new(@x + 70, y-100, "Sleep")
  end

  def awake?
    @sleep_time <= -1
  end

  def play
    if @tiredness < 100 and @sleep_time == -1
      @happiness += rand(10)
      @tiredness += 5
    end
  end

  def sleep
    if awake?
      @sleep_time = 20
    end
  end

  def render args
    x, y = @x, @y
    args.outputs.labels <<[x, y, "#{@type} is #{awake? ? 'Awake' : 'Sleeping'}"]
    y -= 20
    args.outputs.labels <<[x, y, "Happiness: #{@happiness}"]
    y -= 20
    args.outputs.labels <<[x, y, "Tiredness: #{@tiredness}"]
    @play.render args
    @sleep.render args

  end

  def tick args
    @ticks -= 1
    if @ticks <= 0
      @ticks = 100
      action args
    end

    if awake?
      if @play.click(args)
        play
      end

      if @sleep.click(args)
        sleep
      end

      if @tiredness >= 20
        sleep
      end
    end
  end

  def action args
    if not awake?
      @sleep_time -=5
      if @sleep_time <= 0
        @tiredness = 0
        @sleep_time = -1
      end
    else
      @happiness -= rand(3)
      @tiredness += rand(2)

    end
  end
end


def tick args
  args.state.monster ||= Monster.new(10, 700, "Test")
  args.state.monster2 ||= Monster.new(200, 700, "Test")
  args.state.turn_timer ||= 30

  args.state.turn_timer -= 1
  if args.state.turn_timer <= 0
    args.state.turn_timer = 1
    args.state.monster.tick args
    args.state.monster2.tick args
  end

  args.state.monster.render args
  args.state.monster2.render args

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