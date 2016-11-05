FactoryGirl.define do
  factory :daily_log do
    log_date Date.strptime("11-04-2016", "%m-%d-%Y")
    values [80]
  end
end
