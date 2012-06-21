class Puntaje extends Backbone.Model
     initialize: ->
        _.bindAll(this, 'remove')
     
     remove: ->
        this.destroy()

class Puntajes extends Backbone.Collection
    model: Puntaje
    
    comparator: ->
        return -item.get("puntaje") 

class Vista_puntaje extends Backbone.View
    el: $('#registrar_puntaje')
    events: 'click a#btn_lista_puntajes': 'lista_puntaje' 
    
    initialize: ->
        _.bindAll(this, 'lista_puntaje')
        $.parse.init 'ch0uvZw2sfj9JKchnyR9KQxPsw28KKYCbgd3qCBe', '99x5k3k0JSJPYFJSThLgxfhakLirY9zvrqs6LFcs'

    lista_puntaje: ->
        click_lista_puntajes = '1'
        
        $.parse.get 'users', (json) -> 
            lista_puntajes_completa = new Puntajes
            results = json.results
            results.forEach (user) ->
                name = user.username
                email = user.email
                puntaje = user.puntaje
                item = new Puntaje
                    name: name
                    email: email
                    puntaje: puntaje
                lista_puntajes_completa.add item
        
            lista_puntajes = new Puntajes
            total = 0
            _.each lista_puntajes_completa.models, (a) ->
                if total < 10 then
                    punto = new Puntaje 
                        name: a.attributes.name
                        email: a.attributes.email
                        puntaje: a.attributes.puntaje
                    lista_puntajes.add punto
                    total++

tabla_puntajes = new Vista_puntaje