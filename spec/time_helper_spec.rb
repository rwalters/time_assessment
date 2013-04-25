require_relative '../time_helper.rb'

describe TimeHelper do
  context "#AddMinutes" do
    it "is passed a properly formatted string and an integer and it returns a string with the new time" do
      TimeHelper.AddMinutes("10:00 PM", 10).should == "10:10PM"
    end

    it "is passed just a string" do
      expect{ TimeHelper.AddMinutes("10:00 PM") }.to raise_error(ArgumentError)
    end

    it "is passed no parameters" do
      expect{ TimeHelper.AddMinutes() }.to raise_error(ArgumentError)
    end
  end
  context "#new" do
    context "takes a string" do
      specify{ TimeHelper.new("10:00AM").should be_an_instance_of TimeHelper }

      it "retains the time passed in" do
        TimeHelper.new("10:00AM").current_time.should == "10:00AM"
      end

      context "with unacceptable characters" do
        it "of spaces and retains the time passed without the spaces" do
          TimeHelper.new("10 : 00 AM").current_time.should == "10:00AM"
        end

        it "other unacceptable characters and retains the time passed without the characters" do
          TimeHelper.new("10 :Z 00= AM").current_time.should == "10:00AM"
        end
      end

      it "contains lowercase AM/PM and uppercases it" do
        TimeHelper.new("10:00am").current_time.should == "10:00AM"
      end
    end

    context "raises an error" do
      it "if no parameters are passed in" do
        expect{ TimeHelper.new() }.to raise_error(ArgumentError)
      end

      it "if an hour greater than 12 is passed in" do
        expect{ TimeHelper.new("13:00AM") }.to raise_error(RangeError)
      end

      it "if a minute portion over 60 is passed in" do
        expect{ TimeHelper.new("10:77PM") }.to raise_error(RangeError)
      end

      it "if a negative hour portion is passed in" do
        expect{ TimeHelper.new("-10:00PM") }.to raise_error(RangeError)
      end

      it "if a negative minute portion is passed in" do
        expect{ TimeHelper.new("10:-07PM") }.to raise_error(RangeError)
      end

      it "if no AM/PM is passed in" do
        expect{ TimeHelper.new("10:00") }.to raise_error(ArgumentError)
      end
    end
  end

  context "#add_minutes" do
    let(:t_helper) { TimeHelper.new("10:52AM") }

    it "raises an argument error if no parameter" do
      expect{ t_helper.add_minutes() }.to raise_error(ArgumentError)
    end

    it "raises an argument error if nil parameter" do
      expect{ t_helper.add_minutes(nil) }.to raise_error(ArgumentError)
    end

    context "passing in a positive integer adds minutes correctly" do

      it "that do not cross an hour boundary" do
        t_helper.add_minutes(5).should == "10:57AM"
      end

      it "that cross an hour boundary" do
        t_helper.add_minutes(15).should == "11:07AM"
      end

      it "that cross the AM/PM boundary" do
        t_helper.add_minutes(75).should == "12:07PM"
      end

      it "that cross the PM/AM boundary" do
        TimeHelper.new("11:52PM").add_minutes(15).should == "12:07AM"
      end

      it "that cross the 12 to 01 boundary" do
        t_helper.add_minutes(135).should == "1:07PM"
      end
    end

    context "passing in negative integers subtracts minutes correctly" do
      it "that do not cross an hour boundary" do
        TimeHelper.new("10:52AM").add_minutes(-5).should == "10:47AM"
      end

      it "that cross an hour boundary" do
        TimeHelper.new("10:52AM").add_minutes(-55).should == "9:57AM"
      end

      it "that cross the 01 to 12 boundary" do
        TimeHelper.new("1:02PM").add_minutes(-5).should == "12:57PM"
      end

      it "that cross the AM/PM boundary" do
        TimeHelper.new("12:02AM").add_minutes(-5).should == "11:57PM"
      end

      it "that cross the PM/AM boundary" do
        TimeHelper.new("12:02PM").add_minutes(-5).should == "11:57AM"
      end
    end
  end
end
