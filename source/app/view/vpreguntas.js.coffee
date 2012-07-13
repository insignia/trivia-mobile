class window.VistaPreguntas extends Backbone.View
    el: $('#cartel') 

    initialize: ->
        _.bindAll(@, 'siguiente', 'anterior', 'responder')
        @.options.posicion_pregunta = '0'
        App.parseInit()
        
        $.parse.get "classes/preguntas_oficiales", (json) ->
            results = json.results
            results.forEach (pregunta)->
                item = new window.Pregunta 
                            contenido: pregunta.contenido
                            respuesta: pregunta.respuesta
                            posicion: pregunta.posicion
                            opcion1: pregunta.opcion1
                            opcion2: pregunta.opcion2
                            opcion3: pregunta.opcion3
                            opcion4: pregunta.opcion4
                            opcion5: pregunta.opcion5 
                collection.add item

    events: 
        'click a#btn_siguiente': 'siguiente'
        'click a#btn_anterior': 'anterior'
        'click a#btn_responder': 'responder'

    siguiente: =>
        window.orden_hacia_adelante = @.options.posicion_pregunta
        if window.orden_hacia_adelante < 8 then window.orden_hacia_adelante++
        for i in [0..7]
            posicion = collection.at(i).get 'posicion'
            window.respondida = i
            if posicion is window.orden_hacia_adelante
                document.getElementById("contenido").innerHTML = collection.at(i).get 'contenido'
                window.coleccion_opciones = new window.Preguntas
                for j in [1..5]
                    nombre = "opcion" + j
                    if collection.at(i).get(nombre) isnt 'vacio'
                        opcion = new window.Pregunta
                            id: j
                            contenido_opcion: collection.at(i).get nombre
                        window.coleccion_opciones.add opcion
                cookie = $.cookie('respuestas_cookie')
                window.arreglo = cookie.split(",")
                window.respondida = window.arreglo[i] 
                #FIXME: Esta sección debe ser muy similar a la sección de abajo, 
                #ver si se puede unificar esto y otras cosas similares de estos dos métodos.
                @.checkearespuesta()
        @.options.posicion_pregunta = window.orden_hacia_adelante

    anterior: =>
        window.orden_hacia_atras = @.options.posicion_pregunta
        if window.orden_hacia_atras > 1 then window.orden_hacia_atras--
        for i in [0..7]
            posicion = collection.at(i).get 'posicion'
            window.respondida = i
            if posicion is window.orden_hacia_atras
                document.getElementById("contenido").innerHTML = collection.at(i).get 'contenido'
                window.coleccion_opciones = new window.Preguntas
                for j in [1..5]
                    nombre = "opcion" + j
                    if collection.at(i).get(nombre) isnt 'vacio'
                        opcion = new window.Pregunta
                            id: j
                            contenido_opcion: collection.at(i).get nombre
                        window.coleccion_opciones.add opcion
                cookie = $.cookie('respuestas_cookie')
                window.arreglo = cookie.split(",")
                window.respondida = window.arreglo[i] 
                @.checkearespuesta()
        @.options.posicion_pregunta = window.orden_hacia_atras               

    responder: =>
        long = (document.respuestas.opciones.length - 1)
        for i in [0..long]
            if document.respuestas.opciones[i].checked then resp_elegida = document.respuestas.opciones[i].id
        correcta = collection.at(@.options.posicion_pregunta - 1).get 'respuesta'
        window.preg_actual = @.options.posicion_pregunta - 1
        if correcta is resp_elegida
            #FIXME: estos divs se ocultas/muestran en varios lugares, por ahi podría extraerse a un método que reciba un parámetro indicando si se queiren ocultar o desocultar.
            msj.mensajes('0','1','0','0','1','0')
            window.id_correcto = collection.at(@.options.posicion_pregunta - 1).get 'respuesta'
            coleccion_opciones = new window.Preguntas
            for j in [0..5]
                nombre = "opcion" + j
                if collection.at(window.preg_actual).get(nombre) isnt 'vacio'
                    opcion = new window.Pregunta
                        id: j
                        contenido_opcion: collection.at(window.preg_actual).get nombre
                    coleccion_opciones.add opcion
            cookie = $.cookie('respuestas_cookie')
            window.arreglo = cookie.split(",")
            window.arreglo[window.preg_actual] = '1'
            $.cookie('respuestas_cookie', window.arreglo)
            if window.intento is 1 then window.puntaje_total = window.puntaje_total + 10
            if window.intento is 2 then window.puntaje_total = window.puntaje_total + 5
            if window.intento >= 3 then window.puntaje_total = window.puntaje_total + 1
            window.intento = 1
            $('#puntaje').html('')
            $('#puntaje').append(window.puntaje_total + " pts.")
            unos = 0
            for x in [0..7]
                if window.arreglo[x] is '1' then unos++
            if unos is 8 then setTimeout (-> window.location.href = "/#registrar_puntaje"), 250
        else
            window.intento++
            msj.mensajes('1','0','0','0','1','0')
            setTimeout ( -> 
                msj.mensajes('0','0','0','0','1','0')
                if window.preg_actual is 7
                    $('#btn_anterior').click()
                    $('#btn_siguiente').click()
                else
                    $('#btn_siguiente').click()
                    $('#btn_anterior').click()
                msj.mensajes('0','0','1','1','1','0')
            ), 2000              
            $('#puntaje').html('')
            $('#puntaje').append(window.puntaje_total + " pts.")

    checkearespuesta: =>
        if window.respondida is '1'
            msj.mensajes('0','1','0','0','1','0')
        else
            msj.mensajes('0','0','1','1','1','0')
            lista = $('#respuestas', @.el)
            lista.empty()
            $("#plantilla_radio").tmpl(window.coleccion_opciones.toJSON()).appendTo(lista)
            $('#respuestas').listview('refresh') 