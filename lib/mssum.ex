defmodule Mssum do
  # require IEx; IEx.pry
  @github_base_url Application.get_env(:app_vars, :githubBaseUrl)

  def main do
    user = "yothinix"
    repository = "mssum"

    select_milestone_fields = ~w(
      closed_issues created_at description due_on html_url number state title
    )
    milestone = get_latest_milestone(user, repository)
    |> Map.take(select_milestone_fields)

    fields = ~w(
      assignees body closed at created_at html_url labels number state title
    )
    select_issue_fields = fn issue -> Map.take(issue, fields) end

    issues = milestone
    |> get_all_issues(user, repository)
    |> Enum.map(select_issue_fields)

    render_email_template(milestone, issues)
  end

  def render_email_template(milestone, issues) do
    milestone |> IO.inspect
    issues |> IO.inspect
  end

  def get_all_issues(milestone, user, repo) do
    params = %{
      "milestone": milestone["number"],
      "state": "all"
    }
    make_request("/repos/#{user}/#{repo}/issues", params)
    |> Poison.decode!
  end

  def get_latest_milestone(user, repo) do
    make_request("/repos/#{user}/#{repo}/milestones")
    |> Poison.decode!
    |> Enum.at(-1)
    |> Map.get("url")
    |> String.replace(@github_base_url, "")
    |> make_request
    |> Poison.decode!
  end

  def make_request(endpoint \\ "/", params \\ %{}) do
    base_url = "#{@github_base_url}#{endpoint}"
    access_token = Application.get_env(:app_vars, :githubAccessToken)

    case HTTPoison.get(
      base_url,
      ["Authorization": "token #{access_token}"],
      params: params
    ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
