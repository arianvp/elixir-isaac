defmodule Mix.Tasks.Compile.Isaac do

  @shortdoc "Compiles Isaac"

  def run(_) do
    if match? {:win32, _}, :os.type do
      {result, _error_code} = System.cmd("nmake", ["/F", "Makefile.win", "priv\\markdown.dll"], stderr_to_stdout: true)
      Mix.shell.info result
    else
      {result, _error_code} = System.cmd("make", ["priv/isaac.so"], stderr_to_stdout: true)
      Mix.shell.info result
    end
    
    :ok
  end
end
defmodule Isaac.Mixfile do
  use Mix.Project

  def project do
    [app: :isaac,
     version: "0.0.1",
     elixir: "~> 1.0",
     compilers: [:isaac, :elixir, :app],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:isaac_c, github: "arianvp/isaac", tag: "0.0.4", app: false}]
  end
end
