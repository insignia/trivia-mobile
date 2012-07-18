class window.VistaPuntaje extends Backbone.View
    el: $('#registrar_puntaje')

    initialize: ->
        _.bindAll(@, 'lista_puntaje')
        App.parseInit()

    events: 'click a#btn_lista_puntajes': 'lista_puntaje', 'click a#btn_registrar': 'registrar'
    
    lista_puntaje: ->
        window.click_lista_puntajes = '1'
        $.parse.get "users", (json) ->
            lista_puntajes_completa = new window.Puntajes
            json.results.forEach (user) ->
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

    registrar: ->
        if $('#user').val() is '' then alert "Debe ingresar un nombre"
        else
            p = 
                username: $('#user').val()
                email: $('#mail').val()
                puntaje: window.puntaje_total
                password: '123456'
            $.cookie('respuestas_cookie', null)
            window.puntaje_total = 0
            $.parse.post 'users', p, (json) ->
                if json.sessionToken isnt null 
                    alert "Datos cargados correctamente"
                    $('#btn_lista_puntajes').click()

tabla_puntajes = new window.VistaPuntaje
