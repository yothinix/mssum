defmodule Mix.Tasks.Main do
  use Mix.Task

  @shortdoc "Simple main runner"
  def run(_) do
    Mssum.main()
  end
end
