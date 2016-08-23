defmodule CREST.App do
  @moduledoc """
  Main application module - contains logic for configuring ibrowse
  """
  use Application

  @host Application.fetch_env!(:crest, :host)
  @port Application.fetch_env!(:crest, :port)
  @max_sessions Application.fetch_env!(:crest, :max_sessions)
  @max_pipeline_size Application.fetch_env!(:crest, :max_pipeline_size)

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    :ibrowse.set_max_pipeline_size(@host, @port, @max_pipeline_size)
    :ibrowse.set_max_sessions(@host, @port, @max_sessions)

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: CREST.Worker.start_link(arg1, arg2, arg3)
      # worker(CREST.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CREST.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
