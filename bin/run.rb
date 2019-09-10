require_relative '../config/environment'

puts "hello world"

cli = Interface.new
user_object = cli.welcome

if user_object == nil
    system "clear"
    puts "Sorry, we don't have you on file"
    sleep 2
    user_object = cli.welcome
else
    cli.user = user_object
    cli.main_menu
end

loop do
    user_object.reload
    system "clear"
    cli.main_menu
end