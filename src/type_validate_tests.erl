-module(type_validate_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").


-type(user_id() :: {user_id, binary()}).
-type(user() :: #{ user_id := binary(),
                   name := binary(),
                   age => integer()}).

parse_simple_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user_id, []}),
    #{user_id := <<"User ID">>} = Validator(#{user_id => <<"User ID">>}),

    pass.

parse_simple_invalid_key_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user_id, []}),
    ?assertError({badkey, user_id}, Validator(#{user1_id => <<"User ID">>})),
    pass.

parse_simple_invalid_data_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user_id, []}),
    ?assertError({badtype, user_id, 7, binary}, Validator(#{user_id => 7})),
    pass.

parse_maps_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user, []}),
    Data1 = #{user_id => <<"User ID">>,
             name => <<"Name">>,
             age => 35},
    Data2 = #{user_id => <<"User ID">>,
              name => <<"Name">>},

    Data1 = Validator(Data1),
    Data2 = Validator(Data2),
    pass.

parse_badmap_test() ->
    {ok, Validator} = type_validate:parse_spec({?MODULE, user, []}),
    Data1 = #{user_i1d => <<"User ID">>,
             name => <<"Name">>,
             age => 35},
    ?assertError({badkey, user_id},  Validator(Data1)),
    pass.
