class DailyLogController < ApplicationController

  def report
    date = Date.strptime(params[:date], "%m-%d-%Y") rescue nil

    # Create a relation containing all elements for the report
    if date
      case params[:type]
        when "daily"
          logs = DailyLog.where(log_date: date)
        when "mtd"
          logs = DailyLog.where(log_date: date.beginning_of_month .. date)
        when "monthly"
          logs = DailyLog.where(log_date: (date - 1.month) .. date)
        else
          logs = []
      end
   else
     logs = []
   end

    @min = logs.first.values.first rescue 0
    @max = logs.first.values.first rescue 0
    sum = 0
    count = 0
    logs.each do |log|
      @min = log.values.min if log.values.min < @min
      @max = log.values.max if log.values.max > @max
      sum += log.values.sum
      count += log.values.count
    end
    @avg = sum.fdiv(count).ceil rescue 0

  end

  def new
    @value = 0
  end

  def create
    value = Integer(params[:value]) rescue nil
    if value
      daily_log = DailyLog.find_by(log_date: params[:date])
      if daily_log
        daily_log.add(value)
      else
        daily_log = DailyLog.new(log_date: params[:date], values: [value])
      end
      if !daily_log.save
        render :new
      else
        redirect_to daily_log_report_path
      end
    else
      render :new
    end
  end

end
