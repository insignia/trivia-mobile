class window.Puntaje extends Backbone.Model
     initialize: ->
        _.bindAll(this, 'remove')
     
     remove: ->
        this.destroy()

class window.Puntajes extends Backbone.Collection
    model: window.Puntaje
    
    comparator: (item) -> -item.get "puntaje"