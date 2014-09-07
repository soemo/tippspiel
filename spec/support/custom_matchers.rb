RSpec::Matchers.define :be_equal_to_time do |another_date|
  match do |a_date|
    a_date.to_i.should == another_date.to_i
  end
end