#FIXME: Veo que la variable window.arreglo se usa solo en esta clase. ¿ es 
# realmente necesario que sea una variable en el scope global (window) ?

class window.VistaPreguntas extends Backbone.View
    el: $('#cartel') 

    initialize: ->
        _.bindAll(@, 'siguiente', 'anterior', 'responder')
        @options.posicion_pregunta = '0'
        App.parseInit()
        
        $.parse.get "classes/preguntas_oficiales", (json) ->
            json.results.forEach (pregunta)->
                #FIXME: Si una pregunta es creada siempre a través de los datos 
                #de una pregunta en JSON, por ahi podría pensarse en un constructor 
                #específico que procese estos parámetros
                #(eso encapsularia la lógica donde corresponde)
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

    siguiente: ->
        window.orden_hacia_adelante = @options.posicion_pregunta
        if window.orden_hacia_adelante < 8 then window.orden_hacia_adelante++
        #FIXME: Todo el ciclo for son casi iguales en las funciones siguiente
        # y anterior. Extraer la lógica a un sólo metodo compartido por los dos.
        # Lo unico que varia es la linea que dice: 
        #   "if posicion is window.orden_hacia_adelante"
        # y en la otra funcion dice:
        #   "if posicion is window.orden_hacia_atras",
        # es un valor que podría ser pasado como parametro.
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
            #FIXME: la variable cookie me parece que no es necesaria
            arreglo = $.cookie('respuestas_cookie').split(",")
            arreglo[window.preg_actual] = '1'
            $.cookie('respuestas_cookie', arreglo)
            #FIXME: los tres if que vienen no me terminan de convencer,
            # por ahi se podría reemplazar con algo así como:
            #   window.puntaje_total = window.puntaje_total + incremento(window.intento)
            # y definir la funcion incremento para devolve el valor que corresponde
            # segun la cantidad de intentos que se van realizando.
            if window.intento is 1 then window.puntaje_total = window.puntaje_total + 10
            if window.intento is 2 then window.puntaje_total = window.puntaje_total + 5
            if window.intento >= 3 then window.puntaje_total = window.puntaje_total + 1
            window.intento = 1
            $('#puntaje').html('')
            $('#puntaje').append(window.puntaje_total + " pts.")
            unos = 0
            for x in [0..7]
                if arreglo[x] is '1' then unos++
            if unos is 8 then setTimeout (-> window.location.href = "/#registrar_puntaje"), 250
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
            $('#puntaje').html('')
            $('#puntaje').append(window.puntaje_total + " pts.")

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
                #FIXME: la variable cookie me parece que no es necesaria
                arreglo = $.cookie('respuestas_cookie').split(",")
                window.respondida = arreglo[i] 
                @checkea_respuesta()