class window.Vista_puntaje extends Backbone.View
    el: $('#registrar_puntaje')

    initialize: ->
        _.bindAll(this, 'lista_puntaje')
        init = (app_id,rest_key) -> $.parse.init({app_id,rest_key})
        init('Application ID','REST API Key')

    events: 'click a#btn_lista_puntajes': 'lista_puntaje'
    
    lista_puntaje: =>
        window.click_lista_puntajes = '1'
        $.parse.get "users", (json) ->
            lista_puntajes_completa = new window.Puntajes
            results = json.results
            results.forEach (user) ->
                name = user.username
                email = user.email
                puntaje = user.puntaje;
                console.log name + " - email: " + email + " - " + puntaje + " pts."
                item = new window.Puntaje
                    name: name
                    email: email
                    puntaje: puntaje
                lista_puntajes_completa.add item
            window.lista_puntajes = new window.Puntajes
            total = 0
            _.each(lista_puntajes_completa.models, (a) ->
                if total < 10 
                    punto = new window.Puntaje
                        name: a.attributes.name
                        email: a.attributes.email
                        puntaje: a.attributes.puntaje
                    window.lista_puntajes.add punto
                    total++)

tabla_puntajes = new window.Vista_puntaje    



