# wtf am i doing here
# comb through xp and find a best fit function?

xp_per_level = Hash.new(Hash.new)
File.open 'path_xp.txt' do |file|
  file.each_line do |line|
    split = line.split("\t")
    xp_per_level[Integer(split[0])] = split[1].strip
  end
end

require 'json'
puts JSON.pretty_generate xp_per_level
