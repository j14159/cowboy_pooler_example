-module(cowboy_pooler_example_tests).

-include_lib("eunit/include/eunit.hrl").

cowboy_pooler_example_test_() ->
    {setup,
     fun() ->
             ok
     end,
     fun(_) ->
             ok
     end,
     [
      {"cowboy_debugging is alive",
       fun() ->
               %% format is always: expected, actual
               ?assertEqual(howdy, cowboy_pooler_example:hello())
       end}
      ]}.

