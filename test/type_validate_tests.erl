-module(type_validate_tests).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").


-type(user_id() :: {user_id, binary()}).

parse_simple_test() ->
    ?assert(is_function(type_validate:parse_spec({?MODULE, user_id, []}))).
