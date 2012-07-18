class window.Puntaje extends Backbone.Model
     #initialize: (user) ->
     initialize: ->
        _.bindAll(@, 'remove')
        #@name = user.username
        #@email = user.email
        #@puntaje = user.puntaje
     
     remove: ->
        @destroy()

class window.Puntajes extends Backbone.Collection
    model: window.Puntaje
    
    comparator: (item) -> -item.get "puntaje"