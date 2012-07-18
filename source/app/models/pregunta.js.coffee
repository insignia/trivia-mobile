class window.Pregunta extends Backbone.Model
     initialize: (pregunta) ->
        _.bindAll(@, 'remove')
        @contenido = pregunta.contenido
        @respuesta = pregunta.respuesta
        @posicion = pregunta.posicion
        @opcion1 = pregunta.opcion1
        @opcion2 = pregunta.opcion2
        @opcion3 = pregunta.opcion3
        @opcion4 = pregunta.opcion4
        @opcion5 = pregunta.opcion5

     remove: ->
        @destroy()

class window.Preguntas extends Backbone.Collection
    model: window.Pregunta

    comparator: (preg) -> preg.get "posicion"

window.collection = new window.Preguntas