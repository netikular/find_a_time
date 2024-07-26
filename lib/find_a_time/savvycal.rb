require "nokogiri"
require "httparty"
require "json"
require "time"

module FindATime
  class Savvycal
    class Api
      def slots(savvycal_url)
        response = HTTParty.get(savvycal_url)
        html_content = response.body
        JSON.parse(html_content)
      end

      def link_json(savvycal_link)
        response = HTTParty.get(savvycal_link)
        html_content = response.body
        doc = Nokogiri::HTML(html_content)
        data = doc.css("#app").first.attributes["data-page"].value
        JSON.parse(data)
      end
    end

    def initialize(date, link, api = Api.new)
      @date = date
      @savvycal_link = link
      @host = "https://savvycal.com/"
      @api_path = "api/links"
      @api = api
    end

    def from
      @from ||= Time.new(@date.year, @date.month, 1, 0, 0, 0, "UTC")
    end

    def to
      @to ||= Time.new(from.year, from.month + 1, 1, 0, 0, 0, "UTC")
    end

    def from_formatted
      from.strftime("%FT%T.000Z").gsub(":", "%3A")
    end

    def to_formatted
      to.strftime("%FT%T.000Z").gsub(":", "%3A")
    end

    def link_data
      @data_page ||= @api.link_json(@savvycal_link)
    end

    def link
      link_data["props"]["linkId"]
    end

    def user
      link_data["props"]["organizer"]["user"]["id"]
    end

    def find_time
      savvycal_url = "#{@host}#{@api_path}/#{link}/intervals" \
        "?from=#{from_formatted}&until=#{to_formatted}&organizer=#{user}"

      @api.slots(savvycal_url)
    end
  end
end
