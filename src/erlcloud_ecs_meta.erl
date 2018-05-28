-module(erlcloud_ecs_meta).

-include("erlcloud.hrl").
-include("erlcloud_aws.hrl").

-export([get_container_instance_metadata/0,
         get_container_instance_metadata/1]).


%%%---------------------------------------------------------------------------
-spec get_container_instance_metadata() ->
    map() | none().
-spec get_container_instance_metadata( ItemPath :: binary()) ->
    %% TODO More specific error type
    binary() | none().
%%%---------------------------------------------------------------------------
%% @doc Retrieve the ECS container instance meta data for the instance this
%% code is running on. Will fail if not an ECS instance.
%%
%% This convenience function will retrieve the ECS container instance metadata
%% from the file pointed to by the environment variable:
%%  $ECS_INSTANCE_METADATA_FILE
%%
%% ItemPath allows fetching specific pieces of metadata.
%%
%%
get_container_instance_metadata() ->
    case os:getenv("ECS_INSTANCE_METADATA_FILE") of
        false -> error(metadata_not_found);
        Path ->
            {ok, JSON} = file:read_file(Path),
            jsx:decode(JSON, [return_maps])
    end.

get_container_instance_metadata(ItemPath) ->
    Meta = get_container_instance_metadata(),
    maps:get(ItemPath, Meta).
