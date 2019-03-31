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
-export([input/3, parse_spec/1]).

-spec(input(binary(), input_format(), spec()) -> success(term())).
input(Input, Format, Spec) ->
    Data = decode(Input, Format),
    validate(Data, Spec).


-spec(decode(binary(), input_format()) -> term()).
decode(_Input, 'application/xml') ->
    'nyi';
decode(Input, 'text/json') ->
    jsx:decode(Input, [{labels, existing_atom}, return_maps]).


validate(Data, Spec) ->
    Validator = parse_spec(Spec),
    Validator(Data).


-spec(parse_spec(spec()) -> fun((binary()) -> success(term()))).
parse_spec(Spec) ->
    nyi.
