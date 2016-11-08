FactoryGirl.define do
  factory :daily_log do
    log_date Date.today
    values [80]
    user
  end
end
