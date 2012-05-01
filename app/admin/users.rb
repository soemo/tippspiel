ActiveAdmin.register User do
  scope :all, :default => true
  scope :inaktiv do |games|
    games.where('confirmed_at = ? ', nil)
  end
end
