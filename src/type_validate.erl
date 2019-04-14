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


is_type(binary, _key, V) when is_binary(V)->
    V;
is_type(integer, _key, V) when is_integer(V) ->
    V;
is_type(Type, Key, Value) ->
    error({badtype, Key, Value, Type}).

validate_input(_Spec = {{_Module, _FileLine, {type, _, tuple,
                                             [{atom, _, Key},
                                              {type, _, Type1, []}]},_},_},
               Input) when is_map(Input)->

    case maps:get(Key, Input, nokey) of
        nokey ->
            error( {badkey, Key});
        Value ->
            #{Key => is_type(Type1, Key, Value)}
    end;
validate_input(_Spec = {{_Module, _FileLine, {type, _, map,
                                            Fields},_}, _},
               Input) ->
    lists:foldl(fun({type, _, map_field_exact, [{atom, _, FieldName}, {type, _, Type, []}]}, Map) ->
                        case maps:get(FieldName, Input, nokey) of
                            nokey -> error({badkey, FieldName});
                            Value ->
                                maps:put(FieldName,is_type(Type, FieldName,Value), Map)
                        end;
                   ({type, _, map_field_assoc, [{atom, _, FieldName}, {type, _, Type, []}]}, Map) ->
                        case maps:get(FieldName, Input, nokey) of
                            nokey -> Map;
                            Value ->
                                maps:put(FieldName, is_type(Type, FieldName,Value) , Map)
                        end
                end, maps:new(), Fields).




-spec(parse_spec(spec()) -> fun((binary()) -> success(term()))).
parse_spec({Module, Type, Arguments}) ->
    {ok, _Record = #module_types{type_table = TTable}} = type_utils:get_types(Module),
    Spec = maps:get({type, Type, length(Arguments)},TTable),

    {{Module, {_SourceFile, _SourceFileLineNumber},
      {type, _, _Kind,
       _Fields}, _}, any} = Spec,

    Validator  = fun(Input) ->
                        validate_input(Spec, Input)
                 end,
    {ok, Validator}.
