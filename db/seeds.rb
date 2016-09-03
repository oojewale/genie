class Seed
  def create_staff
    5.times do |staff|
      staff = Staff.new
      staff.name = Faker::Name.name
      staff.email = Faker::Internet.email
      staff.phone = Faker::PhoneNumber.phone_number
      staff.save
    end
  end

  def create_user
    5.times do |staff|
      user = User.new
      user.firstname = Faker::Name.name.split.last
      user.lastname = Faker::Name.name.split.last
      user.email = Faker::Internet.email
      user.street_address = Faker::Address.street_name
      user.city = Faker::Address.city
      user.state = Faker::Address.state
      user.phone = Faker::PhoneNumber.phone_number
      user.save
    end
  end

  def create_all
    create_staff
    create_user
  end
end

Seed.new.create_all
