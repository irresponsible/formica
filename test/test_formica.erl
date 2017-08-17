-module(test_formica).

-include_lib("eunit/include/eunit.hrl").

validate_test() ->
  Data = [{<<"name">>, <<"Ozzy Osbourne">>}, {<<"age">>, 68}],
  Validators = #{<<"name">> => fun validate_name/1,
                 <<"age">>  => fun validate_age/1},
  {ok, #{<<"name">> := <<"Ozzy Osbourne">>, <<"age">> := 68}}
    = formica:validate(Data, Validators).

validate_transformation_test() ->
  Data = [{<<"country">>, <<"cy">>}],
  Validators = #{<<"country">> => fun validate_country/1},
  {ok, #{<<"country">> := #{<<"english_name">> := "Cyprus",
                            <<"native_name">>  := "Κύπρος",
                            <<"code">>         := <<"cy">>}}}
    = formica:validate(Data, Validators).

validate_with_missing_field_test() ->
  Data = [{<<"age">>, 68}, {<<"profession">>, <<"rock legend">>}],
  Validators = #{<<"name">> => fun validate_name/1,
                 <<"age">>  => fun validate_age/1},
  {ok, #{<<"age">> := 68, <<"profession">> := <<"rock legend">>}}
    = formica:validate(Data, Validators).

validate_with_errors_test() ->
  Data = [{<<"name">>, <<"Bob">>}, {<<"age">>, -3}],
  Validators = #{<<"name">> => fun validate_name/1,
                 <<"age">>  => fun validate_age/1},
  {error, #{<<"name">> := "Names must be larger than 3 characters",
            <<"age">>  := "Value is an invalid age"}}
    = formica:validate(Data, Validators).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Utilities
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

validate_name(N) when byte_size(N) >= 4 -> {ok, N};
validate_name(_) -> {error, "Names must be larger than 3 characters"}.

validate_age(N) when N >= 0 -> {ok, N};
validate_age(_) -> {error, "Value is an invalid age"}.

validate_country(<<"cy">>) ->
  {ok, #{<<"english_name">> => "Cyprus",
         <<"native_name">>  => "Κύπρος",
         <<"code">>         => <<"cy">>}};
validate_country(_) -> {error, "Unsupported country"}.
