Gym.all.each_with_index do |gym, index|
  whiteboard = Whiteboard.new
  whiteboard.id = index
  whiteboard.gym = gym
  whiteboard.save!
end
