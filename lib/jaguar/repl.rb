require_relative "interpreter"
require "readline"

module Jaguar

  interpreter = Interpreter.new

  if file = ARGV.first
    interpreter.eval File.read(file)
  else
    puts "Jaguar REPL, CTRL+C to quit."
    loop do
      line = Readline::readline("Jaguar >> ")
      Readline::HISTORY.push(line)
      value = interpreter.eval(line)
      puts "Jaguar => #{value.ruby_value.inspect}"
    end
  end

end
