class Button
  def initialize x, y, text
    @name = "#{x}#{text}"
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
    @w, @h = args.gtk.calcstringbox(@text, 2)
    @w += 8
    @h += 4
    w, h = @w, @h

    args.outputs[@name].w = w
    args.outputs[@name].h = h

    # make the background transparent
    args.outputs[@name].background_color = [128, 128, 128, 255]

    # set the blendmode of the label to 0 (no blending)
    # center it inside of the scene
    # set the vertical_alignment_enum to 1 (center)
    args.outputs[@name].labels  << {  x: 6,
                                      y: 14,
                                      text: @text,
                                      blendmode_enum: 1,
                                      vertical_alignment_enum: 1 }

    # add a border to the render target
    args.outputs[@name].borders << { x: 0,
                                      y: 0,
                                      w: args.outputs[@name].w,
                                      h: args.outputs[@name].h }

    # add the rendertarget to the main output as a sprite
    args.outputs.sprites << { x: @x,
                              y: @y,
                              w: args.outputs[@name].w,
                              h: args.outputs[@name].h,
                              angle: 0,
                              path: @name }

  end

  def render_pressed args
    name = "#{@name}-pressed"
    @w, @h = args.gtk.calcstringbox(@text, 2)
    @w += 8
    @h += 4
    w, h = @w, @h
    args.outputs[name].w = w
    args.outputs[name].h = h

    # make the background transparent
    args.outputs[name].background_color = [255, 255, 255, 255]

    # set the blendmode of the label to 0 (no blending)
    # center it inside of the scene
    # set the vertical_alignment_enum to 1 (center)
    args.outputs[name].labels  << {  x: 6,
                                      y: 14,
                                      text: @text,
                                      blendmode_enum: 1,
                                      vertical_alignment_enum: 1 }

    # add a border to the render target
    args.outputs[name].borders << { x: 0,
                                     y: 0,
                                     w: args.outputs[name].w,
                                     h: args.outputs[name].h }

    # add the rendertarget to the main output as a sprite
    args.outputs.sprites << { x: @x,
                              y: @y,
                              w: args.outputs[name].w,
                              h: args.outputs[name].h,
                              angle: 0,
                              path: name }

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
  args.state.monster2 ||= Monster.new(200, 700, "Other")
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
# Better Buttons
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
# Daily 2022-01-20
# Daily 2022-01-21