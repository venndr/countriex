defmodule Countriex.State do
  @type t :: %__MODULE__{
          name: String.t(),
          unofficial_names: list(String.t()),
          country_alpha3: <<_::3>>,
          code: String.t(),
          translations: map(),
          geo: Countriex.Geo.t()
        }

  defstruct [:name, :unofficial_names, :country_alpha3, :code, :translations, :geo]
end
