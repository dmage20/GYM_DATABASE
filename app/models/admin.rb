class Admin < ApplicationRecord
  belongs_to :gym
  belongs_to :user
  def self.users
    self.all.map {|a| a.user}

  end
end

# Gym.find(1).admins.map {|a|  a.user}
# Gym.find(1).admins.users.include?(a)
