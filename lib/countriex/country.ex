defmodule Countriex.Country do
  @default_locale "en"

  @type vat_rate :: nil | integer() | list(integer())

  @type optional_string :: String.t() | nil
  @type optional_boolean :: boolean | nil

  @type t :: %__MODULE__{
          address_format: String.t(),
          alpha2: binary(),
          alpha3: binary(),
          alt_currency: optional_string,
          common_name: map() | nil,
          continent: String.t(),
          country_code: String.t(),
          currency_code: String.t(),
          eea_member: optional_boolean,
          eu_member: optional_boolean,
          gec: String.t(),
          geo: Countriex.Geo.t(),
          international_prefix: String.t(),
          ioc: String.t(),
          iso_long_name: String.t(),
          iso_short_name: String.t(),
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
          postal_code_format: String.t(),
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
    :common_name,
    :continent,
    :country_code,
    :currency_code,
    :gec,
    :geo,
    :international_prefix,
    :ioc,
    :iso_long_name,
    :iso_short_name,
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
    :postal_code_format,
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

  @doc """
  Returns true if the country has a common name for the locale
  """
  @spec common_name?(__MODULE__.t(), locale :: atom() | String.t()) :: boolean()

  def common_name?(country, locale \\ @default_locale)

  def common_name?(%__MODULE__{common_name: nil}, _), do: false

  def common_name?(%__MODULE__{common_name: cn}, locale) when is_atom(locale),
    do: Map.has_key?(cn, locale)

  def common_name?(m, locale) when is_binary(locale),
    do: common_name?(m, String.to_atom(locale))

  @doc """
  Returns the country's common name for the locale or nil
  """
  @spec common_name(__MODULE__.t(), locale :: atom() | String.t()) :: String.t() | nil

  def common_name(country, locale \\ @default_locale)

  def common_name(%__MODULE__{common_name: nil}, _), do: nil

  def common_name(%__MODULE__{common_name: cn}, locale) when is_atom(locale),
    do: Map.get(cn, locale)

  def common_name(m, locale) when is_binary(locale),
    do: common_name(m, String.to_atom(locale))
end
