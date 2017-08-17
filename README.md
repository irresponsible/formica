The irresponsible guild proudly presents...

# Formica

[![Build Status](https://travis-ci.org/irresponsible/formica.svg?branch=master)](https://travis-ci.org/irresponsible/formica)

A tiny forms handling library.

## Usage

First we need to define some validators and a function for validating our form.

```erlang
validate_form(Data) ->
  formica:validate(Data, #{<<"email">>    => fun validate_email/1,
                           <<"password">> => fun validate_password/1}).

validate_email(U) ->
  {ok, EmailReg} = re:compile("^[a-z0-9](\.?[a-z0-9_-]){0,}@[a-z0-9-]+\.([a-z]{1,6}\.)?[a-z]{2,6}$"),
  case re:run(U, EmailReg) of
    {match, _} -> {ok, U};
    nomatch    -> {error, "Email address has invalid format"}
  end.

validate_password(P) when byte_size(P) >= 8 -> {ok, P};
validate_password(_) -> {error, "Passwords must be at least 8 characters long"}.
```

Here are some example uses in the shell

```erlang
%% Valid
1> validate_form([{<<"email">>, <<"a@example.net">>},
                  {<<"password">>, <<"password">>}]).
{ok, #{<<"email">>    := <<"a@example.net">>,
       <<"password">> := <<"password">>}}.
%% Invalid
2> validate_form([{<<"email">>, <<"a@example">>},
                  {<<"password">>, <<"pass">>}]).
{error, #{<<"email">>    := "Email address has invalid format",
          <<"password">> := "Passwords must be at least 8 characters long"}}.
%% Missing fields are returned as-is
3> validate_form([{<<"email">>, <<"a@example.com">>},
                  {<<"password">>, <<"password">>,},
                  {<<"name">>, <<"Ozzy Osbourne">>}]).
{ok, #{<<"email">>    := <<"a@example.net">>,
       <<"password">> := <<"password">>,
       <<"name">>     := <<"Ozzy Osbourne">>}}.
```

## Testing

    $ rebar3 eunit
    
## Contributors

- [Antonis Kalou](https://github.com/kalouantonis)
- [James Laver](https://github.com/jjl)

## License

```
Copyright (c) 2017 Antonis Kalou <kalouantonis@protonmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
