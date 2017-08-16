-module(formica).
-export([collate_errors/1, collate_oks/1, validate/2]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Public API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Run validations against `Data` using the given `ValidationFns`.
%%
%% Data -> formatted as a proplist of {FieldName, FieldVal}
%% ValidationFns -> formated as a map of #{FieldName => Fn}
validate(Data, ValidationFns) ->
  Validations = lists:map(fun(X) ->
                              validate_field(X, ValidationFns)
                          end, Data),
  Errors = formica:collate_errors(Validations),
  case maps:size(Errors) =:= 0 of
    true  -> {ok, formica:collate_oks(Validations)};
    false -> {error, Errors}
  end.

%% Returns a list of tuples that were ok.
collate_oks(Rs) ->
  maps:from_list([X || {ok, X} <- Rs]).

%% Returns a list of tuples that were erroneous.
collate_errors(Rs) ->
  maps:from_list([X || {error, X} <- Rs]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Private API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validate_field({Name, Val0}, ValidationFns) ->
  Validator = maps:get(Name, ValidationFns, fun (X) -> {ok, X} end),
  {Status, Val} = Validator(Val0),
  {Status, {Name, Val}}.
