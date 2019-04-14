%%%-------------------------------------------------------------------
%%% @author Zachary Kessin <zkessin@neptune.local>
%%% @copyright (C) 2019, Zachary Kessin
%%% @doc
%%%
%%% @end
%%% Created : 14 Apr 2019 by Zachary Kessin <zkessin@neptune.local>
%%%-------------------------------------------------------------------
-module(type_utils).


-include("include/types.hrl").
-export([get_types/1]).

get_types(Mod) ->
    case code:is_loaded(Mod) of
        {file,File} ->
            {ok,Core} = dialyzer_utils:get_core_from_beam(File),
            {ok, Records} = dialyzer_utils:get_record_and_type_info(Core),
            {ok, SpecMap, CallBackMap} = dialyzer_utils:get_spec_info(Mod, Core, Records),
            {ok, #module_types{type_table = Records,
                               spec_map = SpecMap,
                               callback_map = CallBackMap
                              }};
        _ ->
            {error, not_found}
    end.
