defmodule MetaTag.MixProject do
  @moduledoc false
  use Mix.Project

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def project do
    [
      app: :meta_tag,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  #
  # Private
  #

  defp deps do
    [
      {:phoenix, "~> 1.6"},
      {:phoenix_html, "~> 3.0"},
    ]
  end
end
