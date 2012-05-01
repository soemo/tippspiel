ActiveAdmin.register Game do

  # Create sections on the index screen
    scope :all, :default => true
    scope :open do |games|
      games.where('finished = ? ', false)
    end
    scope :finished do |games|
      games.where('finished = ? ', true)
    end

end
