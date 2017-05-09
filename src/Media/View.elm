module Media.View exposing (audio)

import Html
import Html.Events as Ev
import Html.Attributes as Attr
import Media.Messages exposing (Msg(..))
import Media.Model exposing (Model, Id)
import Media.Events exposing (onPlaybackPositionChanged, onDurationChanged, onLoaded)


audio : Model -> Html.Html Msg
audio model =
    let
        src =
            Maybe.withDefault "" model.src
    in
        Html.audio
            [ Attr.id model.id
            , onDurationChanged DurationChanged
            , onLoaded StateChanged
            , onPlaybackPositionChanged PlaybackPositionChanged
            , Attr.src src
            ]
            []
