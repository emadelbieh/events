defmodule Events.UserController do
  use Events.Web, :controller

  alias Events.User

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def get_ip_address(conn) do
    case get_req_header(conn, "cf-connecting-ip") do
      [] -> nil
      [ip] -> ip
      ip -> ip
    end
  end

  def create(conn, %{"fingerprint" => fingerprint, "publisher_id" => publisher_id}) do
    uuid = Events.UUIDGenerator.generate(fingerprint, publisher_id)

    case Repo.get_by(User, uuid: uuid) do
      nil ->
        changeset = User.changeset(%User{}, %{
          "uuid" => uuid,
          "context" => %{fingerprint: fingerprint, publisher_id: publisher_id}
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

  def create(conn, %{"ip" => ip, "publisher_id" => publisher_id}) do
    create(conn, %{"fingerprint" => ip, "publisher_id" => publisher_id})
  end

  def create(conn, %{"publisher_id" => publisher_id}) do
    ip = get_ip_address(conn)
    create(conn, %{"fingerprint" => ip, "publisher_id" => publisher_id})
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
end
