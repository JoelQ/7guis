module Counter exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events


main : Program Flags Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }


type alias Flags =
    ()


type alias Model =
    Int


initialModel : Model
initialModel =
    0


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1


view : Model -> Html Msg
view model =
    Html.div []
        [ Html.label
            [ Html.Attributes.for "counter-field"
            , Html.Attributes.style "display" "block"
            ]
            [ Html.text "Counter" ]
        , Html.input
            [ Html.Attributes.value (String.fromInt model)
            , Html.Attributes.readonly True
            , Html.Attributes.id "counter-field"
            ]
            []
        , Html.button [ Html.Events.onClick Increment ] [ Html.text "Count" ]
        ]
