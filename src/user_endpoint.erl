-module(user_endpoint).
-compile([{parse_transform, lager_transform}]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% standard cowboy REST handler functions:
-export([content_types_provided/2, init/3, malformed_request/2, 
         rest_init/2, service_available/2, resource_exists/2]).
%% my handler:
-export([get_user/2]).

%% Magic numbers buried elsewhere suck:
-define(USER_QUERY, "select name,email from users where id=$1").

init({tcp, http}, _, _) ->
    {upgrade, protocol, cowboy_rest}.

rest_init(R, undefined) ->
    {ok, R, pooler:take_member(pg_pool)}.

%% if pooler says no members, kick back a 503.  I
%% do this here because a 503 seems to me the most
%% appropriate response if database connections are
%% <b>currently</b> unavailable.
service_available(R, error_no_members) ->
    {false, R, undefined};
service_available(R, Conn) ->
    {true, R, Conn}.

content_types_provided(R, S) ->
    {[{<<"application/json">>, get_user}], R, S}.

%% Checks to make sure the ID parameter is an int 
%% (or starts with one):
malformed_request(R, C) ->
    {BinId, R2} = cowboy_req:binding(id, R),
    case string:to_integer(binary_to_list(BinId)) of
        {error, _} ->
            ok = pooler:return_member(pg_pool, C, ok),
            {true, R2, undefined};
        {Id, _} ->
            {false, R2, {C, Id}}
    end.

%% I don't wait until here to grab a connection
%% because if there are none available, the caller
%% should get a service unavailable error, not a
%% (likely) incorrect 404.
resource_exists(R, {C, Id}) ->
    {ok, _Cols, Rows} = pgsql:equery(C, ?USER_QUERY, [Id]),
    ok = pooler:return_member(pg_pool, C, ok),

    case Rows of
        [{Name, Email}] ->    
            {true, R, {Id, Name, Email}};
        _ ->
            {false, R, undefined}
    end.

%% The final step is just serialization.
get_user(R, {Id, Name, Email}) ->
    PL = [{id, Id}, {name, Name}, {email, Email}],
    {jsx:encode(PL), R, undefined}.

