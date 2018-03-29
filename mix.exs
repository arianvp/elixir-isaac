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
     description: description,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:isaac_c, github: "arianvp/isaac", tag: "0.0.4", app: false}]
  end

  defp description do
    """
    Isaac is an elixir module for the [ISAAC Stream Cipher](http://burtleburtle.net/bob/rand/isaacafa.html)

    It wraps around  https://github.com/arianvp/ISAAC which is a port of the ISAAC stream cipher to platforms which have words bigger than 32 bits.

    """
  end

  defp package do
    [
      files: ["src", "lib", "priv", "mix.exs", "README*", "LICENSE*"],
      contributors: ["Arian van Putten"],
      licenses: ["Public Domain"],
      links: %{"Github" => "https://github.com/arianvp/elixir-isaac"}
    ]
  end
end
