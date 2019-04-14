%%%-------------------------------------------------------------------
%%% @author Zachary Kessin <zkessin@elixirtraining.org>
%%% @copyright (C) 2019, Zachary Kessin
%%% @doc
%%%
%%% @end
%%% Created : 31 Mar 2019 by Zachary Kessin <zkessin@elixirtraining.org>
%%%-------------------------------------------------------------------
-module(type_validate).
-include_lib("eunit/include/eunit.hrl").
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
    {ok, Validator} = parse_spec(Spec),
    Validator(Data).

validate_input(_Spec = {{_Module, _FileLine, {type, _, tuple,
                                             [{atom, _, Key},
                                              {type, _, _Type1, []}]},_},_},
               Input) when is_map(Input)->
    case maps:get(Key, Input, nokey) of
        nokey ->
            {error, {badkey, Key}};
        Value ->
            {ok, #{Key => Value}}
    end;
validate_input(_Spec = {{_Module, _FileLine, {type, _, map,
                                            _Fields},_}, _},
               _Input) ->
    {ok, b}.



-spec(parse_spec(spec()) -> fun((binary()) -> success(term()))).
parse_spec({Module, Type, Arguments}) ->
    {ok, _Record = #module_types{type_table = TTable}} = type_utils:get_types(Module),
    Spec = maps:get({type, Type, length(Arguments)},TTable),

    {{Module, {_SourceFile, _SourceFileLineNumber},
      {type, _, _Kind,
       _Fields}, _}, any} = Spec,

    Validator  = fun(Input) ->
                         ?debugFmt("~n~n~n~n********************************************************************************~n",[]),
                         ?debugFmt("~n Spec ~p ~n Input ~p~n", [Spec, Input]),

                         validate_input(Spec, Input)
                 end,
    {ok, Validator}.
