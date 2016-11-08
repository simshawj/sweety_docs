require 'rails_helper'

describe DailyLogController do

  context "user signed in" do

    describe "GET #report" do
      let!(:daily_log1) { create(:daily_log, log_date: Date.strptime("11-1-2016", "%m-%d-%Y"), values: [89, 72, 100, 114]) }
      let!(:daily_log2) { create(:daily_log, log_date: Date.strptime("10-28-2016", "%m-%d-%Y"), values: [77, 70, 80, 120]) }
      let!(:daily_log3) { create(:daily_log, log_date: Date.strptime("11-6-2016", "%m-%d-%Y"), values: [100, 110, 105, 111]) }
      let(:report_date) { "11-6-2016" }
      let(:empty_date) { Date.strptime("11-6-2015", "%m-%d-%Y") } 
      context "daily report" do
        let(:report_type) { "daily" }
        it "calculates the daily min" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:min)).to eq(100)
        end
        it "calculates the daily max" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:max)).to eq(111)
        end
        it "calculates the daily avg" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:avg)).to eq(107)
        end
      end

      context "month to date report" do
        let(:report_type) { "mtd" }
        it "calculates the month to date min" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:min)).to eq(72)
        end
        it "calculates the month to date max" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:max)).to eq(114)
        end
        it "calculates the month to date avg" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:avg)).to eq(101)
        end
      end

      context "monthly report" do
        let(:report_type) { "monthly" }
        it "calculates the monthly min" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:min)).to eq(70)
        end
        it "calculates the monthly max" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:max)).to eq(120)
        end
        it "calculates the monthly avg" do
          get :report, params: { type: report_type, date: report_date }
          expect(assigns(:avg)).to eq(96)
        end
      end
   
      it "displays the report view" do
        get :report
        expect(response).to render_template("report")
      end

    end

    describe "GET #new" do
      it "creates a new integer" do
        get :new
        expect(assigns(:value)).to be_a Integer
      end
      it "renders the new template" do
        get :new
        expect(response).to render_template("new")
      end
    end

    describe "GET #create" do
      context "with valid attributes" do
        let (:value) { 89 }
        let (:date) { Date.today }
        context "first entry of the day" do
          it "creates a daily_log entry" do
            expect { post :create, params: {value: value, date: date} }.to change{DailyLog.count}.by(1)
          end
        end
        context "2nd-4th entry of the day" do
          let!(:daily_log) {create(:daily_log)}
          it "does not create a daily_log entry" do
            expect { post :create, params: {value: value, date: date} }.to_not change{DailyLog.count}
          end
          it "increases the value count" do
            expect { post :create, params: {value: value, date: date} }.to change{daily_log.reload.values.length}.by(1)
          end
        end
        it "redirects to the report action" do
          post :create, params: {value: value, date: date}
          expect(response).to redirect_to daily_log_report_path
        end
      end

      context "with invalid attributes" do
        let (:value) { "This is invalid" }
        let (:date) { Date.today }
        it "does not create a daily_log entry" do
          expect { post :create, params: {value: value, date: date} }.to_not change{DailyLog.count}
        end
        it "does not increase the value count" do
          daily_log = create(:daily_log)
          expect { post :create, params: {value: value, date: date} }.to_not change{daily_log.reload.values.count}
        end
        it "renders the new template" do
          post :create, params: {value: value, date: date}
          expect(response).to render_template("new")
        end
      end

      context "with more than 4 values total" do
        let!(:daily_log) { create(:daily_log, values: [94, 78, 100, 82]) }
        let(:value) { 89 }
        let(:date) { Date.today }
        it "does not increase the value count" do
          expect { post :create, params: {value: value, date: date} }.to_not change{daily_log.reload.values.count}
        end
        it "renders the new template" do
          post :create, params: {value: value, date: date}
          expect(response).to render_template("new")
        end
        it "sets the flash message" do
          post :create, params: {value: value, date: date}
          expect(flash[:danger]).to be_present
        end
      end
    end
  end

  context "user not signed in" do
    describe "Get #reports" do
      it "displays an error message" do
        get :report
        expect(flash[:danger]).to be_present
      end
      it "sets all values to 0"
    end
  end
end
