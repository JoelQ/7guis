module TemperatureConverter exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra


main : Program Flags Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , update = update
        , view = view
        }


type alias Flags =
    ()



-- MODEL


type alias Model =
    Float


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg
    = NewCelsius Float
    | NewFarenheit Float


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewCelsius celsius ->
            celsius

        NewFarenheit farenheit ->
            (farenheit - 32) * (5 / 9)



-- VIEW


view : Model -> Html Msg
view model =
    Html.fieldset [] <|
        List.concat
            [ [ Html.legend [] [ Html.text "Temperature Conversion" ] ]
            , floatInput
                { labelText = "º Celsius"
                , id = "celsius"
                , onInput = NewCelsius
                , value = model
                }
            , [ Html.text " = " ]
            , floatInput
                { labelText = "º Farenheit"
                , id = "farenheit"
                , onInput = NewFarenheit
                , value = model * (9 / 5) + 32
                }
            ]



-- FORM HELPERS


type alias InputProps msg =
    { labelText : String
    , id : String
    , onInput : Float -> msg
    , value : Float
    }


floatInput : InputProps msg -> List (Html msg)
floatInput { id, labelText, onInput, value } =
    [ Html.input
        [ Html.Attributes.id id
        , Html.Attributes.type_ "number"
        , Html.Attributes.step "0.1"
        , Html.Attributes.value (String.fromFloat value)
        , onFloatInput onInput
        ]
        []
    , Html.label
        [ Html.Attributes.for id ]
        [ Html.text labelText ]
    ]



-- This is a custom DOM event handler that expects float values to be entered.
-- By default, all the DOM event handlers expect strings. Since we're working
-- with a `<input type="number">`, we can assume that all inputs will be
-- numbers. The associated decoder rejects any events whose value cannot be
-- parsed into an float
--
-- The following two articles dive into the details of how this works:
--
-- 1. https://thoughtbot.com/blog/building-custom-dom-event-handlers-in-elm
-- 2. https://thoughtbot.com/blog/advanced-dom-event-handlers-in-elm


onFloatInput : (Float -> msg) -> Html.Attribute msg
onFloatInput tagger =
    Html.Events.on "input" (Decode.map tagger targetFloatValue)


targetFloatValue : Decoder Float
targetFloatValue =
    Html.Events.targetValue
        |> Decode.andThen (Json.Decode.Extra.fromMaybe "not a float" << String.toFloat)
