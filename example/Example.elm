module Example exposing (main)

import Task
import Media.Model exposing (media)
import Media.Messages as MediaMessages
import Media.Update
import Media.View exposing (audio)
import Html exposing (program, div, span, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)


type alias Model =
    { player : Media.Model.Model
    }


type Msg
    = MediaMessage MediaMessages.Msg
    | Play
    | Pause


init =
    ( { player = { media | id = "potato", src = Just "10. Kettcar - Dunkel.ogg" } }, Cmd.none )


update msg { player } =
    case msg of
        MediaMessage msg ->
            let
                ( nextPlayer, cmd ) =
                    Media.Update.update msg player
            in
                ( { player = nextPlayer }, Cmd.map MediaMessage cmd )

        Play ->
            ( { player = player }, Task.perform MediaMessage (Task.succeed MediaMessages.Play) )

        Pause ->
            ( { player = player }, Task.perform MediaMessage (Task.succeed MediaMessages.Pause) )


view model =
    let
        audioPlayer =
            audio model.player
                |> Html.map MediaMessage

        progressPercentageString =
            toString ((model.player.position / model.player.duration) * 100) ++ "%"

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
