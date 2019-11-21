require "json"
require "file_utils"

base_path = File.expand_path("..", Process.executable_path)

puts base_path

config_raw = File.read(File.join(base_path,"launcher.conf"))

class Option
  JSON.mapping({
    name: String,
    command: String,
  })
end

class Config
  JSON.mapping({
    greeting: String,
    keys: String,
    exit_key: String,
    commands: Array(Option),
  })
end

config = Config.from_json(config_raw)

commands = config.commands

keys = config.keys

exit_key = config.exit_key

if commands.size > keys.size
  puts "too many options, please reduce ammount in config"
else
  puts config.greeting

  conv = {} of String => String

  commands.each_index do |i|
    label = keys[i].to_s

    puts "#{label}: #{commands[i].name}"

    conv[label] = commands[i].command
  end

  puts "#{exit_key}: exit\n\n"

  while true
    choice = STDIN.raw &.read_char.to_s

    if choice == exit_key
      break
    elsif conv.has_key?(choice)
      system conv[choice]

      break
    end
  end
end