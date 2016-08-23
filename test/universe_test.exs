defmodule UniverseTest do
  use ExUnit.Case, async: true

  test "I can get all regions" do
    regions = CREST.get_regions
    assert hd(regions)["name"] == "A-R00001"
  end

  test "I can get an individual region" do
    the_forge = CREST.get_region(10000002)
    assert the_forge["name"] == "The Forge"
  end

  test "I can get all constellations" do
    constellations = CREST.get_constellations
    assert hd(constellations)["name"] == "San Matar"
  end

  test "I can get an individual constellation" do
    kimotoro = CREST.get_constellation(20000020)
    assert kimotoro["name"] == "Kimotoro"
  end

  test "I can get all systems" do
    systems = CREST.get_solar_systems
    assert hd(systems)["name"] == "Tanoo"
  end

  test "I can get an individual system" do
    # Did you know that Poitot is the only named system in Syndicate?
    poitot = CREST.get_solar_system(30003271)
    assert poitot["name"] == "Poitot"
  end

  test "I can get a station from location" do
    jita_iv_cnap = CREST.get_location(60003760)
    assert jita_iv_cnap["station"]["name"] == "Jita IV - Moon 4 - Caldari Navy Assembly Plant"
  end
end
