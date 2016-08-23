defmodule CREST do
  @moduledoc """
  Contains functionality for fetching resources from CREST.
  """

  require HTTPotion

  alias CREST.HTTP

  @root_url "https://#{Application.fetch_env!(:crest, :host)}/"


  #
  # General-purpose queries
  #

  @doc """
  Get CREST root.
  """
  @spec get_root :: Map.t
  def get_root do
    get_all_pages("", "application/vnd.ccp.eve.Api-v5+json; charset=utf-8")
  end


  #
  # Universe
  #

  @doc """
  Gets all regions.
  """
  @spec get_regions() :: Map.t
  def get_regions do
    accept = "application/vnd.ccp.eve.RegionCollection-v1+json; charset=utf-8"
    url = "regions/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets specific region.
  """
  @spec get_region(number | String.t) :: Map.t
  def get_region(region_id) do
    accept = "application/vnd.ccp.eve.Region-v1+json; charset=utf-8"
    url = "regions/#{region_id}/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets all constellations.
  """
  @spec get_constellations() :: Map.t
  def get_constellations do
    accept = "application/vnd.ccp.eve.ConstellationCollection-v1+json; charset=utf-8"
    url = "constellations/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets specific constellation
  """
  @spec get_constellation(number | String.t) :: Map.t
  def get_constellation(constellation_id) do
    accept = "application/vnd.ccp.eve.Constellation-v1+json; charset=utf-8"
    url = "constellations/#{constellation_id}/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets all solar systems.
  """
  @spec get_solar_systems() :: Map.t
  def get_solar_systems do
    accept = "application/vnd.ccp.eve.SystemCollection-v1+json; charset=utf-8"
    url = "solarsystems/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets specific solar system.
  """
  @spec get_solar_system(number | String.t) :: Map.t
  def get_solar_system(system_id) do
    accept = "application/vnd.ccp.eve.System-v1+json; charset=utf-8"
    url = "solarsystems/#{system_id}/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets location info for stations, systems, constellations and regions.
  """
  @spec get_location(number | String.t) :: Map.t
  def get_location(location_id) do
    accept = "application/vnd.ccp.eve.Location-v1+json; charset=utf-8"
    url = "universe/locations/#{location_id}/"
    get_all_pages(url, accept)
  end


  #
  # Types
  #

  @doc """
  Get all types, including those not on market.
  """
  @spec get_types() :: Map.t
  def get_types do
    accept = "application/vnd.ccp.eve.ItemTypeCollection-v1+json; charset=utf-8"
    url = "inventory/types/"
    get_all_pages(url, accept)
  end


  @doc """
  Get specific type.
  """
  @spec get_type(number | String.t) :: Map.t
  def get_type(type_id) do
    accept = "application/vnd.ccp.eve.ItemType-v3+json; charset=utf-8"
    url = "inventory/types/#{type_id}/"
    get_all_pages(url, accept)
  end


  #
  # Market
  #

  @doc """
  Get types on market.
  """
  @spec get_market_types() :: Map.t
  def get_market_types do
    accept = "application/vnd.ccp.eve.MarketTypeCollection-v1+json; charset=utf-8"
    url = "market/types/"
    get_all_pages(url, accept)
  end

  @doc """
  Gets all orders in a region.
  """
  @spec get_orders_in_region(number | String.t) :: Map.t
  def get_orders_in_region(region_id) do
    accept = "application/vnd.ccp.eve.MarketOrderCollectionSlim-v1+json; charset=utf-8"
    url = "market/#{region_id}/orders/all/"
    get_all_pages(url, accept)
  end


  #
  # Helper functions
  #

  @spec get_all_pages(String.t, String.t) :: Map.t
  defp get_all_pages(url, accept) do
    url = @root_url <> url

    {url, accept}
    |> HTTP.get
    |> get_remaining_pages(url, accept)
  end

  @spec get_remaining_pages(Map.t, String.t, String.t) :: Map.t
  defp get_remaining_pages(first_page, url, accept) do
    # Get remaining pages if necessary
    case first_page["pageCount"] do
      nil        -> first_page
      page_count -> do_get_remaining_pages(first_page, url, accept, page_count)
    end
  end

  @spec do_get_remaining_pages(Map.t, String.t, String.t, Number.t) :: List.t
  defp do_get_remaining_pages(first_page, url, accept, page_count) do
    # Fetches all remaing pages in parallel and extracts items
    page_count
    |> Range.new(2)
    |> Enum.map(fn page_num -> (
        Task.async(fn ->
          request_url = url <> "?page=#{page_num}"
          HTTP.get({request_url, accept})
        end))
      end)
    |> Enum.map(fn task -> Task.await(task, 30_000) end)
    |> (fn pages -> [first_page | pages] end).()
    |> Enum.flat_map(&(Map.get(&1, "items")))
  end
end
