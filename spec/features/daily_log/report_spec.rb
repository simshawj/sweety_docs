require 'rails_helper'

describe "starting at reports" do

  context "without selecting a date" do
    context "without data for today" do
      it "displays 0s for all values if no data exists for today" do
        # Visit Reports
        visit "/daily_log/report"
        # Check min, max, avg values
        verify_min_max_avg(0,0,0)
      end
    end
    context "with data for today" do
      # Add a daily_log for today
      let!(:daily_log) { create(:daily_log, values:[80, 90]) }
      it "displays today's results if data exists for today" do
        # Visit Reports
        visit "/daily_log/report"
        # Check min, max, avg values
        verify_min_max_avg(80,90,85)
      end
    end
  end

  context "selecting a date" do
    context "no data exists" do
      it "displays 0s for all values if no data exists" do
        # Visit Reports
        visit "/daily_log/report"
        # Select Date
        select_date("November",4,2016)
        click_button("Get Report")
        # Check min, max, avg values
        verify_min_max_avg(0,0,0)
      end
    end
    context "data exists" do
      let!(:daily_log) { create(:daily_log, log_date: Date.strptime("11-4-2016", "%m-%d-%Y"), values:[80, 90]) }
      it "displays the results for that day" do
        # Visit Reports
        visit "/daily_log/report"
        # Select Date
        select_date("November", 4, 2016)
        click_button("Get Report")
        # Check min, max, avg values
        verify_min_max_avg(80,90,85)
      end
    end
  end

  it "allows the user to add new entries" do
    skip
    # Visit Reports
    # Select New
    # Input Value
    # Select Submit
    # Check, min, max, avg are as inputed
  end

  context "selecting different report types" do
    let!(:daily_log1) { create(:daily_log, log_date: Date.strptime("11-1-2016", "%m-%d-%Y"), values: [89, 72, 100, 114]) }
    let!(:daily_log2) { create(:daily_log, log_date: Date.strptime("10-28-2016", "%m-%d-%Y"), values: [77, 70, 80, 120]) }
    let!(:daily_log3) { create(:daily_log, log_date: Date.strptime("11-6-2016", "%m-%d-%Y"), values: [100, 110, 105, 111]) }
    let(:report_date) { "11-6-2016" }

    it "displays the correct data for daily reports" do
      # Visit Reports
      visit "/daily_log/report"
      # Select Nov 6 2016 for the date
      select_date("November", 6, 2016)
      # Select Daily from report select
      select "Daily", from: "type"
      # Hit Get Report
      click_button("Get Report")
      # Verify min, max, avg
      verify_min_max_avg(100, 111, 107)
    end
    it "displays the correct data for month to date reports" do
      # Visit Reports
      visit "/daily_log/report"
      # Select Nov 6 2016 for the date
      select_date("November", 6, 2016)
      # Select month to date from report select
      select "Month to Date", from: "type"
      # Hit Get Report
      click_button("Get Report")
      # Verify min, max, avg
      verify_min_max_avg(72,114,101)
    end
    
    it "displays the correct data for montlhly reports" do
      # Visit Reports
      visit "/daily_log/report"
      # Select Nov 6 2016 for the date
      select_date("November", 6, 2016)
      # Select Monthly from report select
      select "Monthly", from: "type"
      # Hit Get Report
      click_button("Get Report")
      # Verify min, max, avg
      verify_min_max_avg(70,120,96)
    end
  end

  # Function to check min, max, avg value
  def verify_min_max_avg(min, max, avg)
    expect(page).to have_content ("Minimum: #{min}")
    expect(page).to have_content ("Maximum: #{max}")
    expect(page).to have_content ("Average: #{avg}")
  end

  # Function to change date of displayed report
  def select_date(month, day, year)
    select month, from: "report_date_month"
    select day, from: "report_date_day"
    select year, from: "report_date_year"
  end

end
