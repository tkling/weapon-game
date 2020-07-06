class WelcomeScreen < GameState
  def initialize(window)
    super window
    @vertical_range_array = (20..510).to_a
    @message_y = @vertical_range_array.sample
    @y_set = Time.now
    @message = 'THIS IS WEAPON GAME'
  end

  def update
    if Time.now - window.start_time > 3.5
      notify_ready
    end
  end

  def draw
    if Time.now - @y_set > 0.25
      @message_y = @vertical_range_array.sample
      @y_set = Time.now
    end

    window.huge_font_draw(182, @message_y, 0, Color::YELLOW, @message)
  end

  def key_pressed(id)
    if id == Keys::Enter || id == Keys::Escape || id == Keys::Space
      notify_ready
    end
  end

  def next
    MainMenu
  end
end
