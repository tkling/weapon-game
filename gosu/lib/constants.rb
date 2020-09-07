# frozen_string_literal: true
module ZOrder
  UI = 1
end

module Color
  YELLOW = 0xff_ffff00
end

module Keys
  Q = Gosu::KbQ
  W = Gosu::KbW
  E = Gosu::KbE
  R = Gosu::KbR
  T = Gosu::KbT
  D = Gosu::KbD
  X = Gosu::KbX
  H = Gosu::KbH
  J = Gosu::KbJ
  K = Gosu::KbK
  L = Gosu::KbL
  U = Gosu::KbU
  F1 = Gosu::KbF1
  F5 = Gosu::KbF5
  Space = Gosu::KbSpace
  Enter = Gosu::KbEnter
  Return = Gosu::KbReturn
  Escape = Gosu::KbEscape
  Row1 = Gosu::Kb1
  Row2 = Gosu::Kb2
  Row3 = Gosu::Kb3
  Row4 = Gosu::Kb4
  Row5 = Gosu::Kb5
  Row6 = Gosu::Kb6
  Row7 = Gosu::Kb7
  Row8 = Gosu::Kb8
  Row9 = Gosu::Kb9
  Row0 = Gosu::Kb0
  Up   = Gosu::KbUp
  Down = Gosu::KbDown
  Left = Gosu::KbLeft
  Right = Gosu::KbRight
end

module Controls
  Confirm = Keys::E
  Cancel  = Keys::U

  Right = Keys::H
  Left  = Keys::L
  Up    = Keys::K
  Down  = Keys::J
end

module Experience
  LevelMap ||= begin
    path = File.join(File.dirname(__FILE__), '../..', 'xp_model', 'path_xp.txt')
    File.new(path).each.with_object(Hash.new) do |line, map|
      level, required_xp = line.split(/\s+/)
      map[level.to_i] = required_xp.tr(',', '').to_i
    end.freeze
  end
end

module Elements
  Fire = 'fire'
  Water = 'water'
  Ice = 'ice'
  Thunder = 'thunder'
  Neutral = 'neutral'

  AffinityMap ||= {
    Fire    => { Fire => 1.0, Water => 0.5, Ice => 1.5, Thunder => 1.0, Neutral => 1.0 },
    Water   => { Fire => 1.5, Water => 1.0, Ice => 1.0, Thunder => 0.5, Neutral => 1.0 },
    Ice     => { Fire => 1.0, Water => 0.5, Ice => 1.0, Thunder => 1.5, Neutral => 1.0 },
    Thunder => { Fire => 1.0, Water => 1.5, Ice => 0.5, Thunder => 1.0, Neutral => 1.0 },
    Neutral => { Fire => 1.0, Water => 1.0, Ice => 1.0, Thunder => 1.0, Neutral => 1.0 }
  }
end
