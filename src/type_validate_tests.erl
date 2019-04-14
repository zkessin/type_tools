-module(type_validate_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").


-type(user_id() :: {user_id, binary()}).
-type(user() :: #{ user_id := binary(),
                   name := binary(),
                   age => integer()}).

parse_simple_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user_id, []}),
    {ok, #{user_id := <<"User ID">>}} = Validator(#{user_id => <<"User ID">>}),
    {error,_} = Validator(#{user1_id => <<"User ID">>}),
    pass.

parse_maps_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user, []}),
    {ok, _} = Validator(#{user_id => <<"User ID">>,
                          name => <<"Name">>,
                          age => 35}),
    pass.
