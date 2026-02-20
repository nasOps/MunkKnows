# Integration layer for weather API

require 'net/http'
require 'json'

class WeatherService
  def self.fetch
    # TODO: Replace with real API call
    # Mock for now (OpenAPI-compliant)

    {
      temperature: 6,
      condition: "Cloudy",
      source: "mock"
    }
  end
end