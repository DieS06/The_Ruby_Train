# Rolify User Roles Seeds
%w[guest student mentor academy admin super_admin].each do |role|
    Role.find_or_create_by!(name: role)
end

# User.create!(
#   email: "equix.dgs@gmail.com",
#   first_name: "EquiX",
#   last_name: "Digital",
#   phone_number: "+50687305888",
#   password: "uDdcF8H*ttmkgEy&Yck#",
#   password_confirmation: "uDdcF8H*ttmkgEy&Yck#",
#   confirmed_at: Time.now,
#   state: "active",
#   roles: [Role.find_by(name: "super_admin")]
# )