defmodule Mix.Tasks.Main do
  use Mix.Task

  @shortdoc "Simple main runner"
  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)
    Mssum.main()
  end
end
