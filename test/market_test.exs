defmodule MarketTest do
  use ExUnit.Case, async: true

  test "I can get all market types" do
    types = CREST.get_market_types
    assert hd(types)["type"]["name"] == "Plagioclase"
  end

  test "there are no orders in A-R00001" do
    orders = CREST.get_orders_in_region(11000001)
    assert orders == []
  end

  test "there are orders in Fade" do
    orders = CREST.get_orders_in_region(10000046)
    assert orders != []
  end
end
