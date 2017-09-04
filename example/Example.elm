module Example exposing (main)

import Task
import Media exposing (media, source, position, duration, audio, play, pause)
import Html exposing (program, div, span, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


type alias Model =
    { player : Media.Model
    }


type Msg
    = MediaMessage Media.Msg
    | Play
    | Pause


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


view { player } =
    let
        audioPlayer =
            audio player
                |> Html.map MediaMessage

        progressPercentageString =
            toString ((position player / duration player) * 100) ++ "%"

        progressBar =
            div [ style [ ( "background-color", "black" ), ( "height", "40px" ), ( "width", "300px" ) ] ]
                [ div [ style [ ( "background-color", "red" ), ( "width", progressPercentageString ), ( "height", "100%" ) ] ] [] ]
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
