module Media.Events exposing (onPlaybackPositionChanged, onDurationChanged, onLoaded)

import Media.State exposing (MediaState(Loaded))
import Html
import Html.Events exposing (on, targetValue)
import Json.Decode exposing (Decoder, map, map2, at, float, string, andThen, succeed)


idDecoder : Decoder String
idDecoder =
    at [ "target", "id" ] string


positionDecoder : Decoder Float
positionDecoder =
    at [ "target", "currentTime" ] float


onPlaybackPositionChanged : (Float -> msg) -> Html.Attribute msg
onPlaybackPositionChanged msg =
    let
        decoder =
            map msg
                positionDecoder
    in
        on "timeupdate" decoder


onDurationChanged : (Float -> msg) -> Html.Attribute msg
onDurationChanged msg =
    let
        decoder =
            map msg
                (at [ "target", "duration" ] float)
    in
        on "canplaythrough" decoder


onLoaded : (MediaState -> msg) -> Html.Attribute msg
onLoaded msg =
    map msg (succeed Loaded)
        |> on "loadeddata"
