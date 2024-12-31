defmodule UasWeb.ClientController do
  use UasWeb, :controller

  alias Uas.Accounts
  alias Uas.Accounts.Client

  def new(conn, _params) do
    changeset = Accounts.change_client(%Client{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"client" => client_params}) do
    case Accounts.create_client(client_params) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "Client registered successfully!")
        |> redirect(to: Routes.client_path(conn, :show, client))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    client = Accounts.get_client!(id)
    render(conn, "show.html", client: client)
  end
end
