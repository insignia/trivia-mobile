class window.VistaPuntaje extends Backbone.View
    el: $('#registrar_puntaje')

    initialize: ->
        _.bindAll(@, 'lista_puntaje')
        App.parseInit()

    events: 'click a#btn_lista_puntajes': 'lista_puntaje'
    
    lista_puntaje: ->
        window.click_lista_puntajes = '1'
        $.parse.get "users", (json) ->
            lista_puntajes_completa = new window.Puntajes
            #FIXME: Hace falta realmente asignar una variable results o se puede hacer el each sobre json.results directamente?
            json.results.forEach (user) ->
                #FIXME: hacen falta realmente las variables temporales name, email y puntaje?
                item = new window.Puntaje
                    name: user.username
                    email: user.email
                    puntaje: user.puntaje
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

tabla_puntajes = new window.VistaPuntaje
