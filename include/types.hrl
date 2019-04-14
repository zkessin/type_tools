

-type(input_format() :: 'application/xml'|'text/json').
-type(spec() :: {atom(), atom(), [] | spec()}).
-type(success(X) :: {'ok', X}| {'error', term()}).


-record(module_types, {
                       type_table :: erl_types:type_table(),
                       spec_map :: dialyzer_codeserver:contracts(),
                       callback_map::  dialyzer_codeserver:contracts()
                      }).

-type(module_types() :: #module_types{}).
