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
  F1 = Gosu::KbF1
  F5 = Gosu::KbF5
  Space = Gosu::KbSpace
  Enter = Gosu::KbEnter
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
