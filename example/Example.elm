module Example exposing (main)

import Task
import Media exposing (media, source, position, duration, audio, play, pause, seek)
import Json.Decode
import Html exposing (program, div, span, text, Attribute)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (style)


type alias Model =
    { player : Media.Model
    }


type Msg
    = MediaMessage Media.Msg
    | Play
    | Pause
    | Seek Float


init =
    ( { player = media "potato" <| Just "10. Kettcar - Dunkel.ogg" }, Cmd.none )


update msg { player } =
    case msg of
        MediaMessage msg ->
            let
                ( nextPlayer, cmd ) =
                    Media.update msg player
            in
                ( { player = nextPlayer }, Cmd.map MediaMessage cmd )

        Play ->
            { player = player } ! [ Cmd.map MediaMessage <| play player ]

        Pause ->
            { player = player } ! [ Cmd.map MediaMessage <| pause player ]

        Seek pos ->
            { player = player } ! [ Cmd.map MediaMessage <| seek player (duration player * pos) ]


onSeek : (Float -> msg) -> Attribute msg
onSeek msg =
    Json.Decode.at [ "clientX" ] Json.Decode.float
        |> Json.Decode.andThen (\x -> Json.Decode.succeed (x / 300))
        |> Json.Decode.map msg
        |> on "click"


view { player } =
    let
        audioPlayer =
            audio player
                |> Html.map MediaMessage

        progressPercentageString =
            toString ((position player / duration player) * 100) ++ "%"

        progressBar =
            div
                [ style
                    [ ( "background-color", "black" )
                    , ( "height", "40px" )
                    , ( "width", "300px" )
                    ]
                , onSeek Seek
                ]
                [ div
                    [ style
                        [ ( "background-color", "red" )
                        , ( "width", progressPercentageString )
                        , ( "height", "100%" )
                        ]
                    ]
                    []
                ]
    in
        div []
            [ progressBar
            , span [ onClick Play ] [ text "Play" ]
            , span [ onClick Pause ] [ text "Pause" ]
            , audioPlayer
            ]


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }
