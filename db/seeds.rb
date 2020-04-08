Freelancer.destroy_all
Contractor.destroy_all
Contract.destroy_all

f1 = Freelancer.create(name: "myke", age: 56, dob: 01/26/1994, certifications: "none")
f2 = Freelancer.create(name: "larry", age: 26, dob: 11/16/1964, certifications: "janitor")
f3 = Freelancer.create(name: "anna", age: 36, dob: 02/17/1894, certifications: "coder")
f4 = Freelancer.create(name: "jill", age: 67, dob: 03/26/1934, certifications: "wed designer")

c1 = Contractor.create(name: "bob", company_name: "bob CO", feilds: "mechanic", bio: "we fix things")

puts "loaded"