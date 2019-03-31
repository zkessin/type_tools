

-type(input_format() :: 'application/xml'|'text/json').
-type(spec() :: {atom(), atom(), [] | spec()}).
-type(success(X) :: {'ok', X}| {'error', term()}).
