class TimeHelper
  attr_accessor :current_time

  def self.AddMinutes(start_time, minutes_to_add)
    TimeHelper.new(start_time).add_minutes(minutes_to_add)
  end

  def initialize (start_time)
    @current_time = start_time.upcase.gsub(/[^\d\-\:APM]/,'')
    parse_time()
  end

  def add_minutes(minutes_to_add)
    raise ArgumentError, 'Cannot add nil minutes' if minutes_to_add.nil?
    @current_minute += minutes_to_add.to_i
    handle_minute_overflow
    handle_minute_underflow
    assemble_time
  end

  private

  def parse_time
    split_time = @current_time.split(':')
    @current_hour = split_time[0].to_i
    @current_minute = split_time[1].scan(/[\d\-]+/).first.to_i
    @current_meridian = split_time[1].scan(/[^\d\-]+/).first
    check_boundaries
  end

  def assemble_time
    @current_time = "%d:%02d%s"%[@current_hour, @current_minute, @current_meridian]
  end

  def add_hour(hours_to_add)
    handle_meridian(hours_to_add)

    @current_hour += hours_to_add
    @current_hour -= 12 if @current_hour > 12
    @current_hour += 12 if @current_hour < 1
  end

  def handle_minute_overflow
    while @current_minute > 60
      add_hour(1)
      @current_minute -= 60
    end
  end

  def handle_minute_underflow
    while @current_minute < 0
      add_hour(-1)
      @current_minute += 60
    end
  end

  def handle_meridian(hours_to_add)
    if hours_to_add < 0
      toggle_meridian if @current_hour == 12
    else
      toggle_meridian if @current_hour == 11
    end
  end

  def toggle_meridian
    @current_meridian = (@current_meridian == 'AM'? 'PM' : 'AM')
  end

  def check_boundaries
    raise RangeError, "Hour #{@current_hour} is out of bounds" unless @current_hour > 0 && @current_hour < 13
    raise ArgumentError, "#{@current_meridian} must be AM or PM" unless ['AM', 'PM'].include?(@current_meridian)
    raise RangeError, "Minute #{@current_minute} is out of bounds" unless @current_minute >= 0 && @current_minute < 60
  end
end
