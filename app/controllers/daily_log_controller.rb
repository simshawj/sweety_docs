class DailyLogController < ApplicationController

  def report
    if params[:date]
      # Get date if given in params directly
      @date = Date.strptime(params[:date], "%m-%d-%Y") rescue nil
    elsif params[:report_date]
      # Get date if given from form
      @date = Date.new(params[:report_date][:year].to_i, params[:report_date][:month].to_i, params[:report_date][:day].to_i)
    else
      # If no date is given, use today
      @date = Date.today
    end

    # Create a relation containing all elements for the report
    case params[:type]
      when "daily"
        logs = DailyLog.where(log_date: @date)
      when "mtd"
        logs = DailyLog.where(log_date: @date.beginning_of_month .. @date)
      when "monthly"
        logs = DailyLog.where(log_date: (@date - 1.month) .. @date)
      else
        # If nothing is supplied, provide the daily report
        logs = DailyLog.where(log_date: @date)
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
    # Set date based on how it's presented to the controller
    if params[:date]
      date = params[:date]
    elsif params[:item_date]
      date = Date.new(params[:item_date][:year].to_i, params[:item_date][:month].to_i, params[:item_date][:day].to_i)
    end

    # Create entry if we have a value to try using
    if value
      daily_log = DailyLog.find_by(log_date: date)
      if daily_log
        daily_log.add(value)
      else
        daily_log = DailyLog.new(log_date: date, values: [value])
      end
      if !daily_log.save
        flash[:danger] = daily_log.errors.full_messages.to_sentence.downcase
        render :new
      else
        redirect_to daily_log_report_path
      end
    else
      render :new
    end
  end

end
