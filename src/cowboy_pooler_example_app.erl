-module(cowboy_pooler_example_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Routing = [{'_', [{"/user/:id", user_endpoint, undefined}]}],
    Dispatch = cowboy_router:compile(Routing),

    {ok, Port} = application:get_env(listen_on_port),
    {ok, ListenerCount} = application:get_env(listener_count),

    cowboy:start_http(http, ListenerCount, [{port, Port}], [{env, [{dispatch, Dispatch}]}]),
    lager:start(),

    cowboy_debugging_sup:start_link().

stop(_State) ->
    ok.
