# CREST

[![Build Status](https://drone.element-43.com/api/badges/EVE-Tools/crest/status.svg)](https://drone.element-43.com/EVE-Tools/crest) [![hex.pm version](https://img.shields.io/hexpm/v/crest.svg?style=flat)](https://hex.pm/packages/crest)
[![hex docs](https://img.shields.io/badge/hex-docs-blue.svg)](https://hexdocs.pm/crest/)

A simple client for EVE Online's CREST API. This client correctly specifies version headers for requests, handles transparent, parallel page-walking and connection-pooling. Results are returned as (list of) maps.

*Currently WIP, endpoints are added as needed. Check the docs for available endpoints. Contributions are very welcome!*

## Configuration

You need to define the following variables for configuring the client in your application's `config.exs`:

```elixir
config :crest,
  host: "crest-tq.eveonline.com", # Change host to point it at e.g. sisi
  port: 443,                      # Change port if you're using a custom proxy (TLS must be supported)
  max_sessions: 20,               # Maximum number of parallel connections
  max_pipeline_size: 150          # Maximum size of HTTP pipeline per connection
```

## Installation

The package can be installed as:

  1. Add `crest` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:crest, github: "EVE-Tools/crest"}]
    end
    ```

  2. Ensure `crest` is started before your application:

    ```elixir
    def application do
      [applications: [:crest]]
    end
    ```
