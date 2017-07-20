defmodule Events.Router do
  use Events.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Events do
    pipe_through :browser # Use the default browser stack
  end

  scope "/", Events do
    pipe_through :api

    get "/", PageController, :index

    post "/uuid", UserController, :create
    resources "/users", UserController, except: [:new, :edit]

    post "/track", EventController, :create
    get "/events/search", EventController, :search
    resources "/events", EventController, except: [:new, :edit, :update, :delete]

    get "/dau/search", DauController, :search
  end
end
