module Media.Update exposing (update)

import Task
import Media exposing (play, pause, seek)
import Media.Model exposing (Model, MediaState(..), Error)
import Media.Messages exposing (Msg(..))


commandToMessage : Result Error MediaState -> Msg
commandToMessage res =
    case res of
        Ok state ->
            StateChanged state

        Err err ->
            ErrorHappened err


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            ( model, Task.attempt commandToMessage (play model.id) )

        Pause ->
            ( model, Task.attempt commandToMessage (pause model.id) )

        Seek pos ->
            ( model, Task.attempt commandToMessage (seek model.id pos) )

        StateChanged state ->
            ( { model | state = state }, Cmd.none )

        DurationChanged duration ->
            { model | duration = duration } ! []

        PlaybackPositionChanged position ->
            { model | position = position } ! []

        ErrorHappened err ->
            model ! []
