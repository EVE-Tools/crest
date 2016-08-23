defmodule CRESTTest do
  use ExUnit.Case, async: true

  doctest CREST

  test "I can get the root page" do
    root_page = CREST.get_root()
    assert Map.has_key?(root_page, "serviceStatus")
  end
end
