defmodule Countriex.Country do
  @type vat_rate :: nil | integer() | list(integer())

  @type optional_string :: String.t() | nil
  @type optional_boolean :: boolean | nil

  @type t :: %__MODULE__{
          address_format: String.t(),
          alpha2: <<_::2>>,
          alpha3: <<_::3>>,
          alt_currency: optional_string,
          continent: String.t(),
          country_code: String.t(),
          currency_code: String.t(),
          eea_member: optional_boolean,
          eu_member: optional_boolean,
          gec: String.t(),
          geo: Countriex.Geo.t(),
          international_prefix: String.t(),
          ioc: String.t(),
          languages_official: list(String.t()),
          languages_spoken: list(String.t()),
          name: String.t(),
          nanp_prefix: nil,
          national_destination_code_lengths: list(integer()),
          national_number_lengths: list(integer()),
          national_prefix: String.t(),
          nationality: String.t(),
          number: String.t(),
          postal_code: boolean(),
          region: String.t(),
          start_of_week: String.t(),
          subregion: String.t(),
          un_locode: String.t(),
          unofficial_names: list(String.t()),
          vat_rates:
            %{
              parking: vat_rate,
              reduced: vat_rate,
              standard: vat_rate,
              super_reduced: vat_rate
            }
            | nil,
          world_region: <<_::4>>
        }

  defstruct [
    :address_format,
    :alpha2,
    :alpha3,
    :continent,
    :country_code,
    :currency_code,
    :gec,
    :geo,
    :international_prefix,
    :ioc,
    :name,
    :national_destination_code_lengths,
    :national_number_lengths,
    :national_prefix,
    :nanp_prefix,
    :nationality,
    :number,
    :languages_official,
    :languages_spoken,
    :postal_code,
    :region,
    :unofficial_names,
    :subregion,
    :start_of_week,
    :un_locode,
    :vat_rates,
    :alt_currency,
    :eea_member,
    :eu_member,
    :world_region
  ]
end
