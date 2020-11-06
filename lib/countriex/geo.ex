defmodule Countriex.Geo do
  @type t :: %__MODULE__{
          latitude: float(),
          latitude_dec: float(),
          longitude: float(),
          longitude_dec: float(),
          max_latitude: float(),
          max_longitude: float(),
          min_latitude: float(),
          min_longitude: float()
        }

  defstruct [
    :latitude,
    :latitude_dec,
    :longitude,
    :longitude_dec,
    :max_latitude,
    :max_longitude,
    :min_latitude,
    :min_longitude
  ]
end
