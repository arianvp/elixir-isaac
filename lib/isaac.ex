defmodule Isaac do
  @moduledoc """
  ISAAC stream cipher
  """

  @on_load { :init, 0}

  app = Mix.Project.config[:app]

  def init do
    path = :filename.join(:code.priv_dir(unquote(app)), 'isaac')
    :ok = :erlang.load_nif(path,0)
  end


  def init(_seeds) do
    exit(:nif_library_not_loaded)
  end

  def next_int(_ctx) do
    exit(:nif_library_not_loaded)
  end
end
