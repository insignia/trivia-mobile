class window.Pregunta extends Backbone.Model
     initialize: ->
        _.bindAll(@, 'remove')

     remove: ->
        @destroy()

class window.Preguntas extends Backbone.Collection
    model: window.Pregunta

    comparator: (preg) -> preg.get "posicion"

window.collection = new window.Preguntas