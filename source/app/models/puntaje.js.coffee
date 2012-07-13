class window.Puntaje extends Backbone.Model
     initialize: ->
        _.bindAll(@, 'remove')
     
     remove: ->
        @.destroy()

class window.Puntajes extends Backbone.Collection
    model: window.Puntaje
    
    comparator: (item) -> -item.get "puntaje"