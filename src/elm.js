import { Elm as Counter} from './Counter.elm'
import { Elm as TemperatureConverter} from './TemperatureConverter.elm'

Counter.Counter.init({
  node: document.querySelector('#counter-elm'),
  flags: {}
})

TemperatureConverter.TemperatureConverter.init({
  node: document.querySelector('#temperature-elm'),
  flags: {}
})
