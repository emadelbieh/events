defmodule Events.UserController do
  use Events.Web, :controller

  alias Events.User

  #plug :contextualize when action in [:create]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"ip" => ip, "publisher_id" => publisher_id}) do
    uuid = Events.UUIDGenerator.generate(ip, publisher_id)

    case Repo.get_by(User, uuid: uuid) do
      nil ->
        changeset = User.changeset(%User{}, %{
          "uuid" => uuid,
          "context" => %{ip: ip, publisher_id: publisher_id}
        })

        case Repo.insert(changeset) do
          {:ok, user} ->
            conn
            |> put_status(:created)
            |> put_resp_header("location", user_path(conn, :show, user))
            |> render("show.json", user: user)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Events.ChangesetView, "error.json", changeset: changeset)
        end

      user ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
    end
  end

  def create(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "invalid parameters"})
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Events.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  #defp contextualize(conn, _opts) do
  #  req_headers = conn.req_headers |> Enum.into(%{})

  #  context = %{
  #    ip: req_headers["cf-connecting-ip"] || direct_ip(conn),
  #    country: req_headers["cf-ipcountry"] || "XX",
  #    subid: conn.params["subid"]
  #  }

  #  assign(conn, :context, context)
  #end

  #defp direct_ip(conn) do
  #  case conn.remote_ip do
  #    {a,b,c,d} -> "#{a}.#{b}.#{c}.#{d}"
  #    _ -> nil
  #  end
  #end
end
