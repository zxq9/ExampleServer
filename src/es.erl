%%% @doc
%%% Example Server
%%%
%%% This project is an example of an OTP-structured project in Erlang.
%%% It implements a telnet echo server, echoing whatever is received
%%% to the sender, printing to STDOUT on the host, and broadcasting
%%% to any other connections.
%%% @end

-module(es).
-behavior(application).
-author("Craig Everett <zxq9@zxq9.com>").
-copyright("Craig Everett <zxq9@zxq9.com>").
-license("MIT").

-export([listen/1, ignore/0]).
-export([start/0, start/1]).
-export([start/2, stop/1]).



-spec listen(PortNum) -> Result
    when PortNum :: inet:port_num(),
         Result  :: ok
                  | {error, {listening, inet:port_num()}}.
%% @doc
%% Make the server start listening on a port.
%% Returns an {error, Reason} tuple if it is already listening.

listen(PortNum) ->
    es_client_man:listen(PortNum).


-spec ignore() -> ok.
%% @doc
%% Make the server stop listening if it is, or continue to do nothing if it isn't.

ignore() ->
    es_client_man:ignore().


-spec start() -> ok.
%% @doc
%% Start the server in an "ignore" state.

start() ->
    ok = application:ensure_started(sasl),
    ok = application:start(?MODULE),
    io:format("Starting es...").


-spec start(PortNum) -> ok
    when PortNum :: inet:port_number().
%% @doc
%% Start the server and begin listening immediately. Slightly more convenient when
%% playing around in the shell.

start(PortNum) ->
    ok = start(),
    ok = es_client_man:listen(PortNum),
    io:format("Startup complete, listening on ~w~n", [PortNum]).


-spec start(normal, term()) -> {ok, pid()}.
%% @private
%% Called by OTP to kick things off. This is for the use of the "application" part of
%% OTP, not to be called by user code.
%% See: http://erlang.org/doc/apps/kernel/application.html

start(normal, _Args) ->
    es_sup:start_link().


-spec stop(term()) -> ok.
%% @private
%% Similar to start/2 above, this is to be called by the "application" part of OTP,
%% not client code. Causes a (hopefully graceful) shutdown of the application.

stop(_State) ->
    ok.
