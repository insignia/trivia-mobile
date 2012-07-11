class window.Vista_preguntas extends Backbone.View
    el: $('#cartel') 

    initialize: ->
        _.bindAll(this, 'siguiente', 'anterior', 'responder')
        this.options.posicion_pregunta = '0'
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
        window.orden_hacia_adelante = this.options.posicion_pregunta
        if window.orden_hacia_adelante < 8 then window.orden_hacia_adelante++
        for i in [0..7]
            posicion = collection.at(i).get 'posicion'
            window.respondida = i
            if posicion is window.orden_hacia_adelante
                document.getElementById("contenido").innerHTML = collection.at(i).get 'contenido'
                coleccion_opciones = new window.Preguntas
                for j in [1..5]
                    nombre = "opcion" + j
                    if collection.at(i).get(nombre) isnt 'vacio'
                        opcion = new window.Pregunta
                            id: j
                            contenido_opcion: collection.at(i).get nombre
                        coleccion_opciones.add opcion
                cookie = $.cookie('respuestas_cookie')
                window.arreglo = cookie.split(",")
                window.respondida = window.arreglo[i]
                #FIXME: Esta sección debe ser muy similar a la sección de abajo, 
                #ver si se puede unificar esto y otras cosas similares de estos dos métodos.
                if window.respondida is '1'
                    $('#mensaje_correcto').show()
                    $('#respuestas').hide()
                    $('#div_responder').hide()
                else
                    $('#mensaje_correcto').hide()
                    $('#respuestas').show()
                    $('#div_responder').show()
                    lista = $('#respuestas', this.el)
                    lista.empty()
                    $("#plantilla_radio").tmpl(coleccion_opciones.toJSON()).appendTo(lista)
                    $('#respuestas').listview('refresh')
        this.options.posicion_pregunta = window.orden_hacia_adelante

    anterior: =>
        window.orden_hacia_atras = this.options.posicion_pregunta
        if window.orden_hacia_atras > 1 then window.orden_hacia_atras--
        for i in [0..7]
            posicion = collection.at(i).get 'posicion'
            window.respondida = i
            if posicion is window.orden_hacia_atras
                document.getElementById("contenido").innerHTML = collection.at(i).get('contenido')
                coleccion_opciones = new window.Preguntas
                for j in [1..5] 
                    nombre = "opcion" + j
                    if collection.at(i).get(nombre) isnt 'vacio'
                        opcion = new window.Pregunta
                            id: j
                            contenido_opcion: collection.at(i).get nombre
                        coleccion_opciones.add opcion
                cookie = $.cookie('respuestas_cookie')
                window.arreglo = cookie.split(",")
                window.respondida = window.arreglo[i];
                if window.respondida is '1'
                    $('#mensaje_correcto').show()
                    $('#respuestas').hide()
                    $('#div_responder').hide()
                else
                    $('#mensaje_correcto').hide()
                    $('#respuestas').show()
                    $('#div_responder').show()
                    lista = $('#respuestas', this.el)
                    lista.empty()
                    $("#plantilla_radio").tmpl(coleccion_opciones.toJSON()).appendTo(lista)
                    $('#respuestas').listview('refresh')
        this.options.posicion_pregunta = window.orden_hacia_atras               

    responder: =>
        long = (document.respuestas.opciones.length - 1)
        for i in [0..long]
            if document.respuestas.opciones[i].checked then resp_elegida = document.respuestas.opciones[i].id
        correcta = collection.at(this.options.posicion_pregunta - 1).get 'respuesta'
        window.preg_actual = this.options.posicion_pregunta - 1
        if correcta is resp_elegida
            #FIXME: estos divs se ocultas/muestran en varios lugares, por ahi podría extraerse a un método que reciba un parámetro indicando si se queiren ocultar o desocultar.
            $('#mensaje_error').hide()
            $('#respuestas').hide()
            $('#div_responder').hide()
            $('#mensaje_correcto').show()
            window.id_correcto = collection.at(this.options.posicion_pregunta - 1).get 'respuesta'
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
            $('#mensaje_error').show()
            $('#respuestas').hide()
            setTimeout ( -> 
                $('#mensaje_error').hide() 
                if window.preg_actual is 7
                    $('#btn_anterior').click()
                    $('#btn_siguiente').click()
                else
                    $('#btn_siguiente').click()
                    $('#btn_anterior').click()
                $('#respuestas').show()
            ), 2000              
            $('#puntaje').html('')
            $('#puntaje').append(window.puntaje_total + " pts.")