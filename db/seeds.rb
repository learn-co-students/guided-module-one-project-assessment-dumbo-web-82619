Registration.destroy_all
Gym.destroy_all
User.destroy_all
Program.destroy_all


#Users data--->
kelvin = User.create(username: "klou22", password: "klou22", name: "Kelvin Louie", age: 22, city: "Brooklyn", state: "New York")
don = User.create(username: "donbon", password: "donbon", name: "Don Romano", age: 34, city: "Queens", state: "New York")
bozo1 = User.create(username: "bscode", password: "bscode", name: "Bob Sarkins", age: 27, city: "Denver", state: "Colorado")
bozo2 = User.create(username: "dfcode", password: "dfcode", name: "Dale Flirkin", age: 42, city: "Columbus", state: "Ohio")
bozo3 = User.create(username: "tncode", password: "tncode", name: "Theordore Nobelt", age: 18, city: "Boulder", state: "Colorado")

#Gym data --->
dolphin = Gym.create(name: "Dolphin Fitness", city: "Brooklyn", state: "New York")
blink = Gym.create(name: "Blink Fitness", city: "Brooklyn", state: "New York")
fitness = Gym.create(name: "Planet Fitness", city: "Denver", state: "Colorado")
hour = Gym.create(name: "24-Hour Fitness", city: "Columbus", state: "Ohio")
metro = Gym.create(name: "MetroRock", city: "Pocatello", state: "Idaho")
flatiron = Gym.create(name: "Flatiron Fitness", city: "Manhattan", state: "New York")
pump = Gym.create(name: "Pumping Flatiron", city: "Austin", state: "Texas")
crunch = Gym.create(name: "Crunch Masters", city: "Boston", state: "Massachusetts")
jazz = Gym.create(name: "Jazzercise Island", city: "Wilmington", state: "Delaware")
marvel = Gym.create(name: "Marvelous Workout", city: "Boston", state: "Massachusetts")
run = Gym.create(name: "Run For Your Life", city: "Wichita", state: "Kansas")
new_you = Gym.create(name: "The New You", city: "Portland", state: "Maine")

#Program data --->
spin = Program.create(name: "Zumba Class", gym_id: dolphin.id, category: "Cardio", description: "Instructor-lead, weight-loss program where members will sweat their socks off! Come join for a spin session you will never forget!")
weights = Program.create(name: "Weightlifting", gym_id: blink.id, category: "Weights", description: "Our gym offers state-of-the-art workout equipment for all our members to enjoy. From dumbbells to barbells... We have it all! Personal trainer provided if requested.")
zumba = Program.create(name: "Zumba Class", gym_id: fitness.id, category: "Cardio", description: "Interested in an intense cardio-focused weight-loss program? Look no further for our zumba class is available for all.")
bouldering = Program.create(name: "Bouldering", gym_id: hour.id, category: "Full-Body", description: "Challenge your limits. Ascend to the next level of human physical fitness!")
boxing = Program.create(name: "Kickboxing", gym_id: dolphin.id, category: "Martial-Arts", description: "Get ready for some serious ass-whooping!")
crossfit = Program.create(name: "Cross-Fit", gym_id: blink.id, category: "Full-Body", description: "Extreme is just the beginning! Get fit beyond belief! Weights! Cardio! We do everything!")
top_rope = Program.create(name: "Top-Rope", gym_id: metro.id, category: "Full-Body", description: "Climb to new heights after completing our thorough top-roping course.")
finger = Program.create(name: "Finger Bootcamp", gym_id: flatiron.id, category: "Stretches", description: "Want to destroy your keyboard with a single line of code? Buff up your digits at Flatiron Fitness!")
pumping = Program.create(name: "Weightlifting", gym_id: pump.id, category: "Weights", description: "Strong body, strong mind. 'Nuff said.")
crunching = Program.create(name: "Cross-Fit", gym_id: crunch.id, category: "Full-Body", description: "Crunches and crunches and crunches and crunches and...")
jazzing = Program.create(name: "Dance", gym_id: jazz.id, category: "Full-Body", description: "Get ready for some serious jazz dancing and calorie burning!")
marveling = Program.create(name: "Avengers Builder", gym_id: marvel.id, category: "Martial-Arts", description: "Avengers assemble! Don't forget your ID and credit card 😘")  
running = Program.create(name: "Miles Ahead", gym_id: run.id, category: "Cardio", description: "Don't look back. Your life depends on it!")
new_you_1 = Program.create(name: "The Whole Shebang", gym_id: new_you.id, category: "Full-Body", description: "Total life transformation through a personalized full-body workout routine.")
marvelous = Program.create(name: "Thanos Crusher", gym_id: marvel.id, category: "Martial-Arts", description: "You'll have more than a snap of your fingers at your disposal.")  
fingers = Program.create(name: "Finger Bootcamp II", gym_id: flatiron.id, category: "Stretches", description: "Want to destroy your keyboard again with a single line of code? Buff up your digits at Flatiron Fitness!")
pumpings = Program.create(name: "Extreme Weightlifting", gym_id: pump.id, category: "Weights", description: "Strong body, strong mind. Said again.")

#Registration data --->
reg1 = Registration.create(user_id: kelvin.id, gym_id: dolphin.id, start_date: "June 14, 2019", status: "Active")
reg2 = Registration.create(user_id: don.id, gym_id: blink.id, start_date: "October 17, 2019", status: "Active")
reg3 = Registration.create(user_id: bozo1.id, gym_id: fitness.id, start_date: "December 4, 2016", status: "Inactive")
reg4 = Registration.create(user_id: bozo2.id, gym_id: hour.id, start_date: "February 24, 2019", status: "Active")
reg5 = Registration.create(user_id: bozo3.id, gym_id: dolphin.id, start_date: "March 14, 2018", status: "Inactive")
reg6 = Registration.create(user_id: kelvin.id, gym_id: blink.id, start_date: "June 16, 2009", status: "Inactive")
reg7 = Registration.create(user_id: don.id, gym_id: fitness.id, start_date: "April 19, 2018", status: "Active")

puts "It has been seeded."