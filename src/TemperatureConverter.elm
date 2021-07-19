module TemperatureConverter exposing (main)

import Browser
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Round


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


{-| Use Celsius as our source of truth
-}
type alias Model =
    Celsius


initialModel : Model
initialModel =
    Celsius 0



-- UNITS OF MEASURE
--
-- Since raw floats can represent very different values, I wrap them in a custom
-- type here. This allows the compiler to know the difference between them and
-- prevent me from accidentally using a celsius value when I meant to use a
-- farenheit.
--
-- I decided to implement these myself here because it seemed to be part
-- of the core problem to be solved. On a "real" project I'd probably reach for
-- a unit library like
-- https://package.elm-lang.org/packages/ianmackenzie/elm-units/latest/
--
-- For more on types and units of measure, see this conference talk "A Number by
-- Any Other Name" https://www.youtube.com/watch?v=WnTw0z7rD3E


type Celsius
    = Celsius Float


type Farenheit
    = Farenheit Float


toFarenheit : Celsius -> Farenheit
toFarenheit (Celsius c) =
    Farenheit (c * (9 / 5) + 32)


toCelsius : Farenheit -> Celsius
toCelsius (Farenheit f) =
    Celsius ((f - 32) * (5 / 9))



-- UPDATE


type Msg
    = NewCelsius Celsius
    | NewFarenheit Farenheit


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewCelsius celsius ->
            -- store as-is since Celsius is our source of truth
            celsius

        NewFarenheit farenheit ->
            -- convert to Celsius before storing since that is our source of
            -- truth
            toCelsius farenheit



-- VIEW


view : Model -> Html Msg
view model =
    Html.fieldset [] <|
        Html.legend [] [ Html.text "Temperature Conversion" ]
            :: celsiusInput model
            ++ Html.text " = "
            :: farenheitInput (toFarenheit model)


celsiusInput : Celsius -> List (Html Msg)
celsiusInput (Celsius c) =
    floatInput
        { labelText = "º Celsius"
        , id = "celsius"
        , onInput = NewCelsius << Celsius
        , value = c
        }


farenheitInput : Farenheit -> List (Html Msg)
farenheitInput (Farenheit f) =
    floatInput
        { labelText = "º Farenheit"
        , id = "farenheit"
        , onInput = NewFarenheit << Farenheit
        , value = f
        }



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
        , onFloatInput onInput

        -- Round to 1 decimal point to avoid IEEE 754 floating point precision
        -- issues such numbers ending in .000000000000001
        , Html.Attributes.value (Round.round 1 value)
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
