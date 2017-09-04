module Media
    exposing
        ( --  -- tags
          audio
          -- , video
          -- tasks
        , play
        , pause
        , seek
          -- error
        , Error(..)
          -- Model
        , Model
        , Msg
        , update
        , media
        , source
        , setSource
        , id
        , duration
        , position
        , state
        )

{-| This module is for interacting with the audio apis

# Tags
@docs audio

# Plumbing
@docs Model, media, Msg, update, Error

# Commands
@docs play, pause, seek

# Accessors
@docs id, duration, position, state, source

# Setters
@docs setSource
-}

import Html
import Html.Events as Ev
import Html.Attributes as Attr
import Task exposing (Task)


-- Local imports

import Native.Media
import Media.Events
    exposing
        ( onPlaybackPositionChanged
        , onDurationChanged
        , onLoaded
        )
import Media.State exposing (MediaState(..))


{-| Some errors that can happen when you ask the audio elment to do things
-}
type Error
    = NotFound String
    | InvalidPosition String Float


{-| request the tag associated with `Model` to start playing
-}
play : Model -> Cmd Msg
play model =
    id model
        |> Native.Media.play
        |> Task.attempt taskToMessage


{-| request the tag associated with `Model` to pause
-}
pause : Model -> Cmd Msg
pause model =
    id model
        |> Native.Media.pause
        |> Task.attempt taskToMessage


{-| request the tag associated with `Model` to seek to the given position
-}
seek : Model -> Float -> Cmd Msg
seek model time =
    Native.Media.seek (id model) time
        |> Task.attempt taskToMessage



-- Model


{-| Keeps track of the state of the element for you
-}
type Model
    = Model
        { id : String
        , src : Maybe String
        , state : MediaState
        , position : Float
        , duration : Float
        }


{-| accessor for getting the source that the player is set to
-}
source : Model -> Maybe String
source (Model { src }) =
    src


{-| Get the id of the audio tag
-}
id : Model -> String
id (Model { id }) =
    id


{-| Get the current playback position of the media element
-}
position : Model -> Float
position (Model { position }) =
    position


{-| Get the duration of the current track
-}
duration : Model -> Float
duration (Model { duration }) =
    duration


{-| Get the playback state of the element
-}
state : Model -> MediaState
state (Model { state }) =
    state


{-| Creates a new `Model` that keeps track of a `<audio>` or `<video>` tag.

Make sure each one you create has a unique id and is only used with one tag on a page.  The id is exactly the id of the HTML element, so there can only be one on a page.
-}
media : String -> Maybe String -> Model
media id mSrc =
    Model
        { id = id
        , src = mSrc
        , state = Preroll
        , position = 0.0
        , duration = 0
        }



-- Messages


{-| Messages from the media element's callbacks.

Make sure to include these in your update function so that the library can keep track of the state of your media elements.
-}
type Msg
    = Play
    | Pause
    | Seek Float
    | StateChanged MediaState
    | DurationChanged Float
    | PlaybackPositionChanged Float
    | ErrorHappened Error



-- Update


{-| Sets the source property for the given media element
-}
setSource : Model -> Maybe String -> Model
setSource (Model model) mSrc =
    Model { model | src = mSrc }


setState : Model -> MediaState -> Model
setState (Model model) state =
    Model { model | state = state }


setDuration : Model -> Float -> Model
setDuration (Model model) duration =
    Model { model | duration = duration }


setPosition : Model -> Float -> Model
setPosition (Model model) position =
    Model { model | position = position }


taskToMessage : Result Error MediaState -> Msg
taskToMessage res =
    case res of
        Ok state ->
            StateChanged state

        Err err ->
            ErrorHappened err


{-| Handles updates to media element states.

Use it in your app's update function to keep the `Model`s up to date.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Play ->
            model ! [ play model ]

        Pause ->
            model ! [ pause model ]

        Seek pos ->
            model ! [ seek model pos ]

        StateChanged state ->
            setState model state ! []

        DurationChanged duration ->
            setDuration model duration ! []

        PlaybackPositionChanged position ->
            setPosition model position ! []

        ErrorHappened err ->
            model ! []



-- Tags


{-| Tag for the html `<audio>` element
-}
audio : Model -> Html.Html Msg
audio model =
    let
        src =
            source model
                |> Maybe.withDefault ""
    in
        Html.audio
            [ Attr.id <| id model
            , onDurationChanged DurationChanged
            , onLoaded StateChanged
            , onPlaybackPositionChanged PlaybackPositionChanged
            , Attr.src src
            ]
            []
