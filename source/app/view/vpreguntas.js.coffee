class window.VistaPreguntas extends Backbone.View
    el: $('#cartel') 

    initialize: ->
        _.bindAll(@, 'siguiente', 'anterior', 'responder')
        @options.posicion_pregunta = '0'
        App.parseInit()
        
        $.parse.get "classes/preguntas_oficiales", (json) ->
            json.results.forEach (pregunta)->
                item = new window.Pregunta(pregunta)
                collection.add item

    events: 
        'click a#btn_siguiente': 'siguiente'
        'click a#btn_anterior': 'anterior'
        'click a#btn_responder': 'responder'

    siguiente: ->
        window.orden_hacia_adelante = @options.posicion_pregunta
        if window.orden_hacia_adelante < 8 then window.orden_hacia_adelante++
        @muestra_pregunta_respuestas(window.orden_hacia_adelante)
        @options.posicion_pregunta = window.orden_hacia_adelante

    anterior: ->
        window.orden_hacia_atras = @options.posicion_pregunta
        if window.orden_hacia_atras > 1 then window.orden_hacia_atras--
        @muestra_pregunta_respuestas(window.orden_hacia_atras)
        @options.posicion_pregunta = window.orden_hacia_atras

    responder: ->
        long = (document.respuestas.opciones.length - 1)
        for i in [0..long]
            if document.respuestas.opciones[i].checked then resp_elegida = document.respuestas.opciones[i].id
        correcta = collection.at(@options.posicion_pregunta - 1).get 'respuesta'
        window.preg_actual = @options.posicion_pregunta - 1
        if correcta is resp_elegida
            Mensajes.habilita_respcorrecta()
            window.id_correcto = collection.at(@options.posicion_pregunta - 1).get 'respuesta'
            coleccion_opciones = new window.Preguntas
            for j in [0..5]
                nombre = "opcion" + j
                if collection.at(window.preg_actual).get(nombre) isnt 'vacio'
                    opcion = new window.Pregunta
                        id: j
                        contenido_opcion: collection.at(window.preg_actual).get nombre
                    coleccion_opciones.add opcion
            arreglo = $.cookie('respuestas_cookie').split(",")
            arreglo[window.preg_actual] = '1'
            $.cookie('respuestas_cookie', arreglo)
            window.puntaje_total = window.puntaje_total + @incremento(window.intento)
            window.intento = 1
            if _.all(arreglo, (x) -> (x == '1')) 
                setTimeout (-> window.location.href = "/#registrar_puntaje"), 250
        else
            window.intento++
            Mensajes.habilita_respincorrecta()
            setTimeout ( -> 
                if window.preg_actual is 7
                    $('#btn_anterior').click()
                    $('#btn_siguiente').click()
                else
                    $('#btn_siguiente').click()
                    $('#btn_anterior').click()
                Mensajes.habilita_respuestas()
            ), 2000              
        muestra_puntaje()

    checkea_respuesta: ->
        if window.respondida is '1' then Mensajes.habilita_respcorrecta()
        else
            Mensajes.habilita_respuestas()
            lista = $('#respuestas', @el)
            lista.empty()
            $("#plantilla_radio").tmpl(window.coleccion_opciones.toJSON()).appendTo(lista)
            $('#respuestas').listview('refresh')

    muestra_pregunta_respuestas: (orden) ->
        for i in [0..7]
            posicion = collection.at(i).get 'posicion'
            window.respondida = i
            if posicion is orden
                document.getElementById("contenido").innerHTML = collection.at(i).get 'contenido'
                window.coleccion_opciones = new window.Preguntas
                for j in [1..5]
                    nombre = "opcion" + j
                    if collection.at(i).get(nombre) isnt 'vacio'
                        opcion = new window.Pregunta
                            id: j
                            contenido_opcion: collection.at(i).get nombre
                        window.coleccion_opciones.add opcion
                arreglo = $.cookie('respuestas_cookie').split(",")
                window.respondida = arreglo[i] 
                @checkea_respuesta()

    incremento: (intento) ->
        switch intento
            when 1
                10
            when 2
                5
            else
                1

