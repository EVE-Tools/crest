defmodule TypeTest do
  use ExUnit.Case, async: true

  test "I can get all types" do
    types = CREST.get_types
    assert hd(types)["name"] == "#System"
  end

  test "I can get an individual type" do
    tritanium = CREST.get_type(34)
    assert tritanium["name"] == "Tritanium"
  end
end
