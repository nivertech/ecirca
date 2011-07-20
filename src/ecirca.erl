%% Copyright (C) 2011 by Alexander Pantyukhov <alwx.main@gmail.com>
%%                       Dmitry Groshev       <lambdadmitry@gmail.com>
%% Permission is hereby granted, free of charge, to any person obtaining a copy
%% of this software and associated documentation files (the "Software"), to deal
%% in the Software without restriction, including without limitation the rights
%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the Software is
%% furnished to do so, subject to the following conditions:

%% The above copyright notice and this permission notice shall be included in
%% all copies or substantial portions of the Software.

%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%% THE SOFTWARE.

-module(ecirca).

%% Init
-export([new/2]).
%% Getters
-export([get/2, slice/3]).
%% Setters
-export([set/3, update/3, push/2, push_many/3, push_list/2]).
%% Compile-time constants
-export([max_slice/0, max_size/0]).
%% Current circa properties
-export([size/1]).
%% Persistence
-export([load/1, save/1]).

-export_types([res/0, maybe_value/0, value/0]).

-on_load(nif_init/0).

-define(STUB, not_loaded(?LINE)).
-define(APPNAME, ?MODULE).
-define(LIBNAME, ?MODULE).
-define(NULLVAL, 16#FFFFFFFFFFFFFFFF).

-type res()         :: <<>>.
-type maybe_value() :: non_neg_integer() | empty.
-type value()       :: non_neg_integer().
-type nonneg()      :: non_neg_integer().
-type ecirca_type() :: last | max | min | sum | avg.

-spec new(pos_integer(), ecirca_type()) -> {ok, res()} |
                                           {error, max_size}.
new(_Size, _Type) -> ?STUB.

%% TODO: this one returns {ok, Val} instead of {ok, Res}
-spec set(res(), pos_integer(), maybe_value()) -> {ok, res()} |
                                                  {error, not_found}.
set(_Res, _I, _Val) -> ?STUB.

%% TODO
-spec update(res(), pos_integer(), maybe_value()) -> {ok, res()} |
                                                     {error, not_found}.
update(Res, I, Val) ->
    case set(Res, I, Val) of
        {ok, _} -> {ok, Res};
        T -> T
    end.

-spec push(res(), maybe_value()) -> {ok, res()}.
push(_Res, _Val) -> ?STUB.

%% TODO: all
-spec push_many(res(), nonneg(), maybe_value()) -> {ok, res()}.
push_many(Res, N, Val) ->
    [push(Res, Val) || _ <- lists:seq(1, N)],
    {ok, Res}.

%% TODO: all
-spec push_list(res(), [maybe_value()]) -> {ok, res()}.
push_list(_Res, _Lst) -> ?STUB.

-spec get(res(), pos_integer()) -> {ok, maybe_value()} |
                                   {error, not_found}.
get(_Res, _I) -> ?STUB.

%% TODO: reversed list when reversed args
-spec slice(res(), pos_integer(), pos_integer()) -> {ok, [maybe_value()]} |
                                                    {error, slice_too_big}.
slice(_Res, _Start, _End) -> ?STUB.

-spec max_size() -> {ok, pos_integer()}.
max_size() -> ?STUB.

-spec max_slice() -> {ok, pos_integer()}.
max_slice() -> ?STUB.

-spec size(res()) -> {ok, pos_integer()}.
size(_Res) -> ?STUB.

%% TODO
-spec load(binary()) -> {ok, res()}.
load(_Bin) -> ?STUB.

%% TODO
-spec save(res()) -> {ok, binary()}.
save(_Res) -> ?STUB.

%% @doc Loads a NIF
-spec nif_init() -> ok | {error, _}.
nif_init() ->
    SoName = case code:priv_dir(?APPNAME) of
        {error, bad_name} ->
            case filelib:is_dir(filename:join(["..", priv])) of
                true ->
                    filename:join(["..", priv, ?MODULE]);
                _ ->
                    filename:join([priv, ?MODULE])
            end;
        Dir ->
            filename:join(Dir, ?MODULE)
    end,
    erlang:load_nif(SoName, 0).

not_loaded(Line) ->
    exit({not_loaded, [{module, ?MODULE}, {line, Line}]}).


