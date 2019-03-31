%%%-------------------------------------------------------------------
%%% @author Zachary Kessin <zkessin@elixirtraining.org>
%%% @copyright (C) 2019, Zachary Kessin
%%% @doc
%%%
%%% @end
%%% Created : 31 Mar 2019 by Zachary Kessin <zkessin@elixirtraining.org>
%%%-------------------------------------------------------------------
-module(type_validate).

-include("include/types.hrl").
-export([validate_input/3])

-spec(validate_input(binary(), input_format(), spec()) -> {'ok', term()} | {'error', term()}).
input(Input, Format, Spec) ->
    Data = decode(Input, Format),
    validate(Data, Spec).



decode(Input, 'application/xml') ->
    'nyi';
decode(Input, 'text/json') ->
    jsx:decode(Input, [{labels, existing_atom}, return_maps]).


validate(Data, Spec) ->
    Validator = parse_spec(Spec),
    Validator(Data).


parse_spec(_) ->
    nyi.
