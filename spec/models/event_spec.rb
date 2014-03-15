require 'spec_helper'

describe Event do

  describe ".create" do
    it "doesn't create duplicates" do
      event1 = Event.create(:twitter_handle => "star")
      event2 = Event.create(:twitter_handle => "star")
      expect(Event.count).to eq(1)

      event3 = Event.create(:twitter_handle => "star light", :name => "star")
      event4 = Event.create(:twitter_handle => "star bright", :name => "star")
      expect(Event.count).to eq(2)
    end

    it "should end after it starts" do
      event = Event.create(:twitter_handle => "timey wimey", :start_date => Date.today, :end_date => Date.today - 3)
      expect(Event.count).to eq(0)
      expect(event.errors.count).to eq(1)
    end

    it "returns the correct json" do
      event = Event.create({
        :name => "star",
        :description => "make a wish",
        :event_type => "supernatural",
        :location => "night sky",
        :start_date => Date.today,
        :end_date => Date.today + 1,
        :twitter_handle => "star_light",
        :website_url => "www.firstwish.com",
        :logo => "star.png"
        })

      json = event.as_json
      expect(json.keys.length).to eq(10)
      expect(json.keys).to match_array([:id, :name, :description, :event_type, :location, :start_date, :end_date, :twitter_handle, :website_url, :logo])
    end
  end

  describe "#is_past?" do
    it "returns true for a past event" do
      event = Event.create({ :name => "fall of the roman empire", :start_date => Date.today - 1538.years })
      expect(event.is_past?).to be true
    end

    it "returns false for an event today" do
      event = Event.create({ :name => "very good day", :start_date => Date.today })
      expect(event.is_past?).to be false
    end

    it "returns false for a future event" do
      event = Event.create({ :name => "the rapture", :start_date => Date.today + 666.years })
      expect(event.is_past?).to be false
    end
  end

  describe '.upcoming_range' do
    it 'returns a range from today to the end of 3 months from now' do
      expect(Event.upcoming_range).to eq(Date.today..3.months.from_now.end_of_month)
    end
  end

  describe "#is_upcoming?" do
    it "returns false for a past event" do
      event = Event.create({ :name => "fall of the roman empire", :start_date => Date.today - 1538.years })
      expect(event.is_upcoming?).to be false
    end

    it "returns true for an event today" do
      event = Event.create({ :name => "very good day", :start_date => Date.today })
      expect(event.is_upcoming?).to be true
    end

    it "returns true for a near future event" do
      event = Event.create({ :name => "christmas", :start_date => Date.today + 2.months})
      expect(event.is_upcoming?).to be true

      event = Event.create({ :name => "christmas", :start_date => Date.today + 3.months})
      expect(event.is_upcoming?).to be true
    end

    it "returns false for a far future event" do
      event = Event.create({ :name => "the rapture", :start_date => Date.today + 666.years })
      expect(event.is_past?).to be false
    end
  end

  describe '#set_dates' do
    it "sets start_date and end_date" do
      e = Event.create(:twitter_handle => 'spring')
      start_date = Date.today
      end_date = Date.today + 5

      e.set_dates(start_date, end_date)

      expect(e.start_date).to eq(start_date)
      expect(e.end_date).to eq(end_date)
    end

    it "sets start_date" do
      e = Event.create(:twitter_handle => 'fall')
      start_date = Date.today

      e.set_dates(start_date)

      expect(e.start_date).to eq(start_date)
    end
  end

  describe '#formatted_start_and_end_date' do
    before :each do
      @event = Event.create(:twitter_handle => "hackathon")
    end

    it "returns empty for no start date" do
      expect(@event.formatted_start_and_end_date).to be_nil
    end

    it "formats with only a start date" do
      @event.update_attribute(:start_date, Date.today)

      expect(@event.formatted_start_and_end_date).to eq("#{Date.today.to_formatted_s(:long)}")
    end

    it "formats with start and end date" do
      @event.update_attributes(:start_date => Date.today, :end_date => Date.today + 1)

      expect(@event.formatted_start_and_end_date).to eq("#{Date.today.to_formatted_s(:long)} - #{(Date.today + 1).to_formatted_s(:long)}")
    end

    it "lets you set a format" do
      @event.update_attribute(:start_date, Date.today)

      expect(@event.formatted_start_and_end_date(:short)).to eq("#{Date.today.to_formatted_s(:short)}")
    end
  end

end
