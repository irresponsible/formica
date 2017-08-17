-module(prop_formica).

-include_lib("proper/include/proper.hrl").

not_2tup() ->
  ?SUCHTHAT(T, term(), not (is_tuple(T) andalso tuple_size(T) =:= 2)).

status() ->
  oneof([ok,error]).

value() ->
  ?LET({S,V},{atom(),term()}, {S,V}).

return_value() ->
  ?LET({S,V},{status(),value()}, {S,V}).

return_values() ->
  list(return_value()).

%% When these were lists, we could simply count them, but maps naturally dedupe
%% I don't think there's an efficient way to test this without basically duplicating logic
prop_collaters() ->
  ?FORALL({Ts,Fs},{return_values(), list(not_2tup())},
	  begin
	    MyOs = maps:from_list([T || {ok,T} <- Ts]),
	    MyEs = maps:from_list([T || {error,T} <- Ts]),
	    Os = formica:collate_oks(Ts),
	    Es = formica:collate_errors(Ts),
	    Os2 = formica:collate_oks(Fs),
	    Es2 = formica:collate_errors(Fs),
	    MyOs =:= Os andalso MyEs =:= Es andalso Os2 =:= #{} andalso Es2 =:= #{}
	  end).

%% prop_validate() ->
%%   ?FORALL({},{},
%% 	  begin
%% 	    true
%% 	  end).

