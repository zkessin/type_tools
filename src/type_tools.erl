%%%-------------------------------------------------------------------
%%% @author Zachary Kessin <zkessin@elixirtraining.org>
%%% @copyright (C) 2019, Zachary Kessin
%%% @doc
%%%
%%% @end
%%% Created : 31 Mar 2019 by Zachary Kessin <zkessin@elixirtraining.org>
%%%-------------------------------------------------------------------

-module(type_tools).
-include("include/types.hrl").

%% API exports
-export([validate_input/3]).

%%====================================================================
%% API functions
%%====================================================================

-spec(validate_input(binary(), input_format(), spec()) -> success(term())).
validate_input(Input, Format, Spec) ->
    type_validate:input(Input, Format, Spec).
