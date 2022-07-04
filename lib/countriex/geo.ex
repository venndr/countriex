defmodule Countriex.Geo do
  @type t :: %__MODULE__{
          latitude: float(),
          longitude: float(),
          max_latitude: float(),
          max_longitude: float(),
          min_latitude: float(),
          min_longitude: float()
        }

  defstruct [
    :latitude,
    :longitude,
    :max_latitude,
    :max_longitude,
    :min_latitude,
    :min_longitude
  ]
end
