require "rails_helper"

describe "New Log Form" do

  context "no entry for date" do

    it "creates a new entry for the date selected" do
      # Visit new log page
      visit "daily_log/new"
      # Select Date
      select "November", from: "item_date_month"
      select 4, from: "item_date_day"
      select 2016, from: "item_date_year"
      # Input reading
      fill_in "value", with: "80"
      # Hit Submit
      click_button("Submit")
      # Goto Date
      select "November", from: "report_date_month"
      select 4, from: "report_date_day"
      select 2016, from: "report_date_year"
      click_button("Get Report")
      # Verify that avg shows the value
      expect(page).to have_content ("Average: 80")
    end
  end

  context "entry already created" do
    let!(:daily_log) { create(:daily_log) }
    it "adds a new value if date has values" do
      # Vist new log page
      visit "daily_log/new"
      # Input Reading
      fill_in "value", with: "80"
      # Hit Submit
      click_button("Submit")
      # Verify Avg shows an average has been done
      expect(page).to have_content ("Average: 80")
    end
  end

  context "4 values already" do
    let!(:daily_log) { create(:daily_log, values: [90,90,90,90]) }
    it "displays an error if entry couldn't be saved" do
      # Visit new log page
      visit "daily_log/new"
      # Input 5th value
      fill_in "value", with: "90"
      # Hit Submit
      click_button("Submit")
      # Verify error message
      expect(page).to have_content("4 values")
    end
  end

end
