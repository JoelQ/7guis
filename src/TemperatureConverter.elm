module TemperatureConverter exposing (main)

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



-- MODEL


{-| These strings represent what the user has typed and what was last rendered
for the two fields. These two are not necessarily in sync since the spec says:

> When the user enters a non-numerical string into C the value in F is not
> updated and vice versa.

Thus, one cannot always be derived from the other. This means we cannot store
only a single value as the source of truth.

Note that we store strings here rather than parsed floats so that we're able to
distinguish between the user typing "1.0" and "1.00". We will be using this when
re-rendering the input and we want to make sure not to change what the user
typed. Example of the problems not doing this can cause here:
<https://ellie-app.com/dMYdbSsYHkxa1>

-}
type alias Model =
    { celsius : String
    , farenheit : String
    }


initialModel : Model
initialModel =
    { celsius = "0"
    , farenheit = "32"
    }



-- UPDATE


type Msg
    = NewCelsius String
    | NewFarenheit String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NewCelsius newCelsius ->
            { model
                | celsius = newCelsius
                , farenheit =
                    case String.toFloat newCelsius of
                        Just n ->
                            String.fromFloat <| toFarenheit n

                        Nothing ->
                            model.farenheit
            }

        NewFarenheit newFarenheit ->
            { model
                | farenheit = newFarenheit
                , celsius =
                    case String.toFloat newFarenheit of
                        Just n ->
                            String.fromFloat <| toCelsius n

                        Nothing ->
                            model.celsius
            }


toFarenheit : Float -> Float
toFarenheit c =
    c * (9 / 5) + 32


toCelsius : Float -> Float
toCelsius f =
    (f - 32) * (5 / 9)



-- VIEW


view : Model -> Html Msg
view { celsius, farenheit } =
    Html.fieldset [] <|
        Html.legend [] [ Html.text "Temperature Conversion" ]
            :: celsiusInput celsius
            ++ Html.text " = "
            :: farenheitInput farenheit


celsiusInput : String -> List (Html Msg)
celsiusInput c =
    numberInput
        { labelText = "º Celsius"
        , id = "celsius"
        , onInput = NewCelsius
        , value = c
        }


farenheitInput : String -> List (Html Msg)
farenheitInput f =
    numberInput
        { labelText = "º Farenheit"
        , id = "farenheit"
        , onInput = NewFarenheit
        , value = f
        }



-- FORM HELPERS


type alias InputProps msg =
    { labelText : String
    , id : String
    , onInput : String -> msg
    , value : String
    }


numberInput : InputProps msg -> List (Html msg)
numberInput { id, labelText, onInput, value } =
    [ Html.input
        [ Html.Attributes.id id
        , Html.Attributes.type_ "number"
        , Html.Events.onInput onInput
        , Html.Attributes.value value
        ]
        []
    , Html.label
        [ Html.Attributes.for id ]
        [ Html.text labelText ]
    ]
