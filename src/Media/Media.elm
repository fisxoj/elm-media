module Media
    exposing
        (--  -- tags
        --   audio
        -- , video
        --   -- events
        -- , onPlaybackPositionChanged
        -- , onDurationChanged
          -- tasks
        , play
        , pause
        , seek
          -- error
        , Error(..)
        )

import Native.Media
import Media.View exposing (audio, video)
import Media.Events exposing (onPlaybackPositionChanged, onDurationChanged)
import Media.Model exposing (Position)


type Error
    = NotFound Id
    | InvalidPosition Id Position


play : Id -> Task Error ()
play id =
    Native.Media.play id


pause : Id -> Task Error ()
pause id =
    Native.Media.play id


seek : Id -> Int -> Task Error ()
seek id time =
    Native.Media.seek id time
