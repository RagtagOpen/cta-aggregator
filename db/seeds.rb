# This seeds file is only intended for preproduction environments
# DO NOT run this is production
# It's common for seed scripts to have a command for deleting existing records.
# There is no such command here in order to protect against someone 
# accidentally running `rake db:seed` in production



names = ["Santa Claus", "Richard Nixon", "John Doe", "Jon Lovitz", "Fred FlintStone", "Wilma Filtstone", "Selena Kyle"]

lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

contacts = []

50.times do 
  name = names.sample
  contacts << Contact.create!(name: name, email: "#{name.gsub('','')}_#{SecureRandom.hex}@example.com")
end

locations = []

25.times do |i|
  location = Location.create!(
    address: "#{Random.rand(250)} #{["W","E", "N", "S"].sample}. #{Random.rand(250)} #{["St", "Ave", "Blvd"].sample}.",
    city: ["New York", "San Francisco", "Spokane", "Dallas", "Bannock", "Baltimore", "Los Angeles"].sample,
    state: ["NY", "CA", "WA", "TX", "ID", "MD"].sample,
    zipcode: rand.to_s[2..6]
  )
  locations << location
end

CTA::CTA_TYPES.each do |cta_name, cta_value|
  25.times do |i|

    start_at = DateTime.new([2017, 2018, 2019].sample, rand(1..12), rand(1..25), rand(1..22), rand(1..40))
    cta = CTA.new(
      title: lorem_ipsum.split(/\W+/).sample(5).join(' '),
      description: lorem_ipsum.split(/\W+/).sample(25).join(' '),
      website: "www.#{lorem_ipsum.split(/\W+/).sample}.com",
      free: [true, false].sample,
      start_at: start_at,
      end_at: start_at + ([1,2,3,4].sample).hours,
      cta_type: cta_name,
      contact_id: (contacts.sample).id
    )

    if cta_name == :phone
      call_script = CallScript.create!(text: lorem_ipsum.split(/\W+/).sample(25).join(' '))
      cta.call_script_id = call_script.id
    elsif cta_name == :onsite
      cta.location_id = (locations.sample).id
    end

    cta.save!

  end
end
