Registration.destroy_all
Gym.destroy_all
User.destroy_all
Program.destroy_all


#Users data--->
benny = User.create(name: "Kelvin Louie", age: 22, city: "Brooklyn", state: "New York")
dan = User.create(name: "Don Romano", age: 34, city: "Queens", state: "New York")
bozo1 = User.create(name: "Bob Sarkins", age: 27, city: "Denver", state: "Colorado")
bozo2 = User.create(name: "Dale Flirkin", age: 42, city: "Columbus", state: "Ohio")
bozo3 = User.create(name: "Theordore Nobelt", age: 18, city: "Boulder", state: "Colorado")

#Gym data --->
dolphin = Gym.create(name: "Dolphin Fitness", city: "Brooklyn", state: "New York")
blink = Gym.create(name: "Blink Fitness", city: "Brooklyn", state: "New York")
fitness = Gym.create(name: "Planet Fitness", city: "Denver", state: "Colorado")
hour = Gym.create(name: "24-Hour Fitness", city: "Columbus", state: "Ohio")

#Program data --->
spin = Program.create(name: "Zumba Class", gym_id: dolphin.id, category: "Cardio", description: "Instructor-lead, weight-loss program where members will sweat their socks off! Come join for a spin session you will never forget!")
weights = Program.create(name: "Weightlifting", gym_id: blink.id, category: "Weights", description: "Our gym offers state-of-the-art workout equipment for all our members to enjoy. From dumbbells to barbells... We have it all! Personal trainer provided if requested.")
zumba = Program.create(name: "Zumba Class", gym_id: fitness.id, category: "Cardio", description: "Interested in an intense cardio-focused weight-loss program? Look no further for our zumba class is available for all.")
bouldering = Program.create(name: "Bouldering", gym_id: hour.id, category: "Full-Body", description: "Challenge your limits. Ascend to the next level of human physical fitness!")
boxing = Program.create(name: "Kickboxing", gym_id: dolphin.id, category: "Martial-Arts", description: "Get ready for some serious ass-whooping!")
crossfit = Program.create(name: "Cross-Fit", gym_id: blink.id, category: "Full-Body", description: "Extreme is just the beginning! Get fit beyond belief! Weights! Cardio! We do everything!")

#Registration data --->
reg1 = Registration.create(user_id: benny.id, gym_id: dolphin.id, start_date: "June 14, 2019", status: "Active")
reg2 = Registration.create(user_id: dan.id, gym_id: blink.id, start_date: "October 17, 2019", status: "Active")
reg3 = Registration.create(user_id: bozo1.id, gym_id: fitness.id, start_date: "December 4, 2016", status: "Inactive")
reg4 = Registration.create(user_id: bozo2.id, gym_id: hour.id, start_date: "February 24, 2019", status: "Active")
reg5 = Registration.create(user_id: bozo3.id, gym_id: dolphin.id, start_date: "March 14, 2018", status: "Inactive")
reg6 = Registration.create(user_id: benny.id, gym_id: blink.id, start_date: "June 16, 2009", status: "Inactive")
reg7 = Registration.create(user_id: dan.id, gym_id: fitness.id, start_date: "April 19, 2018", status: "Active")

puts "It has been seeded."