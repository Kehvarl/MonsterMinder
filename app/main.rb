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
    if args.inputs.mouse.click
      click
    end
    args.outputs.sprites << [@x, @y, @size, @size, sprite]
  end
end

def tick args
  args.state.monster ||= Monster.new(64, 64)

  args.state.monster.tick args
end
