defmodule Mix.Tasks.Countriex.GenerateData do
  alias Countriex.{Country, Geo, State}

  @countries_json_url "https://raw.githubusercontent.com/hexorx/countries/master/lib/countries/cache/countries.json"
  @states_json_url "https://raw.githubusercontent.com/hexorx/countries/master/lib/countries/data/subdivisions/"
  @country_keys Country.__struct__() |> Map.keys()

  def run(_) do
    countries =
      countries_from_url()
      |> tap(&update_cache/1)
      |> parse_countries_json()
      |> parse(%Country{})
      |> sort

    states = states_from_url(countries)

    %{countries: countries, states: states}
    |> generate_file_content
    |> write_to_file
  end

  @countries_cache "cache/countries.json"
  defp update_cache(countries), do: File.write!(@countries_cache, countries)

  defp countries_from_url do
    HTTPoison.start()

    @countries_json_url
    |> HTTPoison.get!()
    |> Map.get(:body)
  end

  defp parse_countries_json(countries) do
    countries
    |> Poison.decode!(keys: :atoms)
    |> Enum.map(fn {_, %{iso_short_name: name} = country} ->
      country
      |> Map.take(@country_keys)
      |> Map.put(:name, name)
      |> Map.put(:__struct__, Country)
      |> struct()
    end)
  end

  defp states_from_url(countries) do
    Application.ensure_all_started(:yaml_elixir)

    Enum.flat_map(countries, fn country ->
      response = HTTPoison.get!(@states_json_url <> "#{country.alpha2}.yaml")

      case response.status_code do
        200 ->
          response
          |> Map.get(:body)
          |> YamlElixir.read_from_string()
          |> assign_state_code
          |> string_to_atom
          |> Enum.filter(&Map.has_key?(&1, :name))
          |> parse(%State{})
          |> Enum.map(&Map.merge(&1, %{country_alpha3: country.alpha3}))

        404 ->
          []
      end
    end)
  end

  defp assign_state_code(data) do
    {:ok, data} = data
    for {state_code, value} <- data, do: Map.merge(value, %{code: state_code})
  end

  defp string_to_atom(data) when is_list(data), do: Enum.map(data, &string_to_atom(&1))

  defp string_to_atom(data) when is_map(data) do
    {:ok, atomized_data} = Morphix.atomorphiform(data)
    atomized_data
  end

  defp parse(data, type) when is_list(data), do: Enum.map(data, &parse(&1, type))

  defp parse(data, type) when is_map(data) do
    geo =
      case Map.get(data, :geo, %{}) do
        nil -> %{}
        results -> parse_geo(results, type)
      end

    type
    |> Map.merge(data)
    |> Map.merge(%{geo: geo})
  end

  defp parse_geo(geo_data, _type) when geo_data == %{}, do: %Geo{}

  defp parse_geo(geo_data, %Country{}),
    do: %Geo{
      latitude: geo_data.latitude |> to_float,
      longitude: geo_data.longitude |> to_float,
      max_latitude: geo_data.max_latitude |> to_float,
      max_longitude: geo_data.max_longitude |> to_float,
      min_latitude: geo_data.min_latitude |> to_float,
      min_longitude: geo_data.min_longitude |> to_float
    }

  defp parse_geo(geo_data, %State{}),
    do: %Geo{
      latitude: geo_data.latitude |> to_float,
      longitude: geo_data.longitude |> to_float,
      max_latitude: geo_data |> Map.get(:max_latitude) |> to_float,
      max_longitude: geo_data |> Map.get(:max_longitude) |> to_float,
      min_latitude: geo_data |> Map.get(:min_latitude) |> to_float,
      min_longitude: geo_data |> Map.get(:min_longitude) |> to_float
    }

  defp sort(countries), do: Enum.sort_by(countries, &Map.get(&1, :alpha2))

  defp generate_file_content(%{countries: countries, states: states}) do
    """
    defmodule Countriex.Data do
      @moduledoc \"\"\"
      This module is generated using json files in the ruby [countries](https://github.com/hexorx/countries) gem.

      To regenerate this file, run `mix countriex.generate_data`
      \"\"\"

      def countries do
    #{format(countries)}
      end

      def states do
    #{format(states)}
      end
    end
    """
  end

  defp write_to_file(content), do: File.write!("lib/countriex/data.ex", content)

  defp to_float(nil), do: nil

  defp to_float(val) when is_float(val), do: val

  defp to_float(str) do
    {result, _} = Float.parse("#{str}")
    result
  end

  defp format(data),
    do:
      inspect(data,
        pretty: true,
        limit: 10_000,
        width: 0,
        charlists: :as_lists,
        custom_options: [sort_maps: true],
        structs: true
      )
end
