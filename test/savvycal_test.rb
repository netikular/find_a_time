require "test_helper"

class SavvycalTest < Minitest::Test
  def mock_the_api
    @api = Minitest::Mock.new
    @savvycal = FindATime::Savvycal.new(@test_date, @savvycal_link, @api)
    @api.expect :slots, mock_slots, [String]
    @api.expect(:link_json,
      {"props" =>
        {
          "linkId" => "link_01EXJ5XEWXV6D8FRM80C9PZ0XC",
          "organizer" => {
            "user" => {
              "id" => "user_01EXJ5XEWB9RVXC4ZFRJTX8S0B"
            }
          }
        }},
      [String])
  end

  def mock_slots
    {"slots" =>
      [{"duration" => 60, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-29T17:30:00Z", "startAt" => "2024-07-29T16:30:00Z", "eventId" => nil},
        {"duration" => 60, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T17:00:00Z", "startAt" => "2024-07-30T16:00:00Z", "eventId" => nil},
        {"duration" => 60, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T16:45:00Z", "startAt" => "2024-07-30T15:45:00Z", "eventId" => nil},
        {"duration" => 60, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T16:30:00Z", "startAt" => "2024-07-30T15:30:00Z", "eventId" => nil},
        {"duration" => 60, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T16:15:00Z", "startAt" => "2024-07-30T15:15:00Z", "eventId" => nil},
        {"duration" => 60, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T16:00:00Z", "startAt" => "2024-07-30T15:00:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-26T22:00:00Z", "startAt" => "2024-07-26T21:30:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-26T21:45:00Z", "startAt" => "2024-07-26T21:15:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T16:00:00Z", "startAt" => "2024-07-30T15:30:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T15:45:00Z", "startAt" => "2024-07-30T15:15:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T15:30:00Z", "startAt" => "2024-07-30T15:00:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T20:15:00Z", "startAt" => "2024-07-30T19:45:00Z", "eventId" => nil},
        {"duration" => 30, "rank" => 1, "allowance" => "open", "endAt" => "2024-07-30T20:00:00Z", "startAt" => "2024-07-30T19:30:00Z", "eventId" => nil}],
     "intervals" =>
      [{"rank" => 1, "endAt" => "2024-07-30T20:15:00Z", "startAt" => "2024-07-30T19:30:00Z"},
        {"rank" => 1, "endAt" => "2024-07-30T17:30:00Z", "startAt" => "2024-07-30T15:00:00Z"},
        {"rank" => 1, "endAt" => "2024-07-29T22:00:00Z", "startAt" => "2024-07-29T21:30:00Z"},
        {"rank" => 1, "endAt" => "2024-07-29T21:00:00Z", "startAt" => "2024-07-29T19:30:00Z"},
        {"rank" => 1, "endAt" => "2024-07-29T17:30:00Z", "startAt" => "2024-07-29T15:00:00Z"},
        {"rank" => 1, "endAt" => "2024-07-26T22:00:00Z", "startAt" => "2024-07-26T21:15:00Z"}]}
  end

  def live_api
    @savvycal = FindATime::Savvycal.new(@test_date, @savvycal_link)
  end

  def setup
    @test_date = Time.new(2024, 7, 26, 0, 0, 0, "UTC")
    @savvycal_link = "https://savvycal.com/kevinpratt/chat?view=month&day=2024-07-26"

    mock_the_api # comment out this line to hit a mock api
    # live_api # uncomment this line to hit the live url
  end

  def test_it_starts_up
    slots = @savvycal.find_time
    refute_empty slots
  end

  def test_from
    assert_equal Time.new(2024, 7, 1, 0, 0, 0, "UTC"), @savvycal.from
    assert_equal "2024-07-01T00%3A00%3A00.000Z", @savvycal.from_formatted
    assert_equal Time.new(2024, 8, 1, 0, 0, 0, "UTC"), @savvycal.to
    assert_equal "2024-08-01T00%3A00%3A00.000Z", @savvycal.to_formatted
  end

  def test_finds_variables
    assert_equal "user_01EXJ5XEWB9RVXC4ZFRJTX8S0B", @savvycal.user
    assert_equal "link_01EXJ5XEWXV6D8FRM80C9PZ0XC", @savvycal.link
  end
end
