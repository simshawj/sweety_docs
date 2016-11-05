require 'rails_helper'

describe DailyLog do

  it { is_expected.to validate_presence_of(:log_date) }
  it { is_expected.to validate_presence_of(:values) }

  describe "uniqueness" do
    subject { create(:daily_log) }
    it { is_expected.to validate_uniqueness_of(:log_date) }
  end

  it "allows for multiple values to be inputed" do
    daily_log = build_stubbed(:daily_log)
    expect(daily_log).to be_valid
    daily_log.add(98)
    expect(daily_log).to be_valid
    daily_log.add(87)
    expect(daily_log).to be_valid
    daily_log.add(100)
    expect(daily_log).to be_valid
  end

  it "allows a max of four values to be inputed" do
    daily_log = build_stubbed(:daily_log)
    daily_log.add(89)
    daily_log.add(82)
    daily_log.add(90)
    daily_log.add(120)
    expect(daily_log).to_not be_valid
  end

  it "requires each value to be an integer" do
    expect(build_stubbed(:daily_log, values: ["asdf"])).to_not be_valid
    expect(build_stubbed(:daily_log, values: [83, Date.today])).to_not be_valid
    expect(build_stubbed(:daily_log, values: [83, 84, nil])).to_not be_valid
    expect(build_stubbed(:daily_log, values: [83, 90, 56, 83.21])).to_not be_valid

  end

end
