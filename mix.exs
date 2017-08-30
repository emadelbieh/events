defmodule Events.Mixfile do
  use Mix.Project

  def project do
    [app: :events,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Events, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :postgrex, :uuid, :httpoison, :timex, :ex_aws, :poison, :hackney,
                    :crontab, :quantum]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:uuid, "~> 1.1"},
     {:poison, "~> 2.2.0", override: true},
     {:distillery, "~> 1.0", runtime: false},
     {:httpoison, "~> 0.11.1"},
     {:timex, "~> 3.1.21"},
     {:ex_aws, "~> 1.0"},
     {:poison, "~> 2.0"},
     {:hackney, "~> 1.6"},
     {:crontab, "~> 1.0.0"},
     {:quantum, ">= 1.9.0"},
   ]
  end
end
