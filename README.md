# 7 GUIs in Elm

[![Netlify Status](https://api.netlify.com/api/v1/badges/274874f9-2df4-4e9a-b611-0b4f29f2badc/deploy-status)](https://app.netlify.com/sites/7guis-elm/deploys)

This is an [Elm] implementation of the [7 GUIs project]. See the GUIs on the
[live site] or scroll down for more info on each one.


[Elm]: https://elm-lang.org
[7 GUIs project]: https://eugenkiss.github.io/7guis/tasks
[live site]: https://7guis-elm.netlify.app/

## Counter

* [Spec](https://eugenkiss.github.io/7guis/tasks/#counter)
* [Live example](https://7guis-elm.netlify.app/#counter)
* [Source](src/Counter.elm)

A counter that counts up and down is the [classic intro-to-elm example]. The
7guis variant is even simpler because it only counts up. It is simple enough
that one can realistically attempt to play code golf.

I chose to write the code in a more standard style, even where it wasn't
strictly necessary. For example, I defined a `Msg` type even though there is
only a single message variant.

<img width="236" alt="screenshot of counter" src="https://user-images.githubusercontent.com/1006966/126097401-8c21395b-b978-4a61-868d-9b57ce46f262.png">

[classic intro-to-elm example]: https://guide.elm-lang.org/

## Temperature Converter

* [Spec](https://eugenkiss.github.io/7guis/tasks/#temp)
* [Live example](https://7guis-elm.netlify.app/#temperature)
* [Source](src/TemperatureConverter.elm)

This GUI provided two main challenges. Firstly, the (mostly) bi-directional
flow. Typing into either input affects the value of the other (except if invalid
input is typed). Normally I'd want to store a single value as the source of
truth but the edge-cases mean I actually need to keep track of two values.

Secondly, the intuitive thing is to store a float but parsing a float out of a
string is a lossy operation. For example, `"1.0"` and `"1.00"` both parse out to
the same float. See [this example] of how that can break things. The solution
was to store the raw strings the user typed on the `Model`.

I'm a big fan of [creating custom types for units of measure]. My earlier
implementation had custom `Celsius` and `Farenheit` values. However, as part of
addressing the two issues above, I now store and pass around strings just about
everywhere. In a real project, I'd be looking for opportunities to add them back
the moment we added any kind of logic around the numbers.

<img width="495" alt="screenshot of temperature converter" src="https://user-images.githubusercontent.com/1006966/126097396-538546bb-c718-430e-a2ee-0d35f0e1bec9.png">

[this example]: https://ellie-app.com/dMYdbSsYHkxa1
[creating custom types for units of measure]: https://www.youtube.com/watch?v=WnTw0z7rD3E

## Flight Booker

TODO

## Timer

TODO

## CRUD

TODO

## Circle Drawer

TODO

## Cells

TODO

## License

The repo is provided under the [MIT License](LICENSE).
