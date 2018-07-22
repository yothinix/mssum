defmodule Mssum do
  def main do
    make_request()
  end

  def make_request(endpoint \\ "/") do
    base_url = "https://api.github.com#{endpoint}"

    case HTTPoison.get(base_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
        body |> Poison.decode!
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
