Pregunta = Backbone.Model.extend({
     initialize: function(){
        _.bindAll(this, 'remove');
     },
     remove: function(){
        this.destroy();
     }
});

Preguntas = Backbone.Collection.extend({
    model: Pregunta,
    comparator: function(preg){
        //a medida que se van agregando preguntas a la coleccion, se ordenan de forma ascendente por id.
        return preg.get("posicion"); 
    },
});

Vista_preguntas = Backbone.View.extend({
    el: $('#cartel'), //elemento del DOM que contiene todo lo referido a la vista (boton, ul, li), es el ID de la seccion TimeEntries
    collection: {}, //creo la coleccion con preguntas
    posicion_pregunta: '',
    events: {
            'click a#btn_siguiente': 'siguiente', //Boton par avanzar preguntas
            'click a#btn_anterior': 'anterior', //Boton par avanzar preguntas
            'click a#btn_responder': 'responder', //Boton responder la pregunta
    },
    initialize: function(){
        _.bindAll(this, 'siguiente', 'anterior', 'responder');
        this.options.posicion_pregunta = '0',
        $.parse.init({
            app_id : 'F1iXn056CKTE2k4RUMZeiLkaoWC9geoKsKKeMeYd', // <-- enter your Application Id here 
            rest_key : 'zjeGNFeqTB8XuXhcrVDdfkInx8656DAnDcfR0Nr8' // <--enter your REST API Key here    
        });
        $.parse.get("classes/preguntas_oficiales", function(json){
            collection = new Preguntas();
            results = json.results;
            results.forEach(function(pregunta) {
                var contenido = pregunta.contenido;
                var respuesta = pregunta.respuesta; //respuesta correcta a la pregunta
                var posicion = pregunta.posicion; //lo uso para avanzar a través de las preguntas
                var opcion1 = pregunta.opcion1; //respuestas posibles a la pregunta
                var opcion2 = pregunta.opcion2;
                var opcion3 = pregunta.opcion3;
                var opcion4 = pregunta.opcion4;
                var opcion5 = pregunta.opcion5;
                var item = new Pregunta({contenido: contenido, respuesta: respuesta, posicion: posicion, opcion1: opcion1, opcion2: opcion2, opcion3: opcion3, opcion4: opcion4, opcion5: opcion5});
                console.log("posicion_pregunta: " + pregunta.posicion);
                collection.add(item);
            });
        });
    },
    siguiente: function(){
        console.log("posicion_pregunta: " + this.options.posicion_pregunta);
        var orden_hacia_adelante = this.options.posicion_pregunta;
        //primera pregunta empieza en posicion 1
        if(orden_hacia_adelante < 8){
            orden_hacia_adelante++;
        }
        var i;
        for(i=0; i<8; i++){
            var posicion = collection.at(i).get('posicion');
            var respondida = i;
            if (posicion == orden_hacia_adelante) {
                document.getElementById("contenido").innerHTML = collection.at(i).get('contenido');
                //Genero coleccion de opciones segun la pregunta
                //Las preguntas tienen un máximo de 5 respuestas posibles
                //Para cada pregunta, genero las 5 opciones
                //Las 5 opciones se guardan en 1 coleccion nueva
                var j = 1;
                var coleccion_opciones = new Preguntas();
                while(j<6) {
                    var nombre = "opcion" + j;
                    if(collection.at(i).get(nombre) != 'vacio') //si la opcion tiene algo
                    {
                        var opcion = new Pregunta({id: j, contenido_opcion: collection.at(i).get(nombre)});
                        coleccion_opciones.add(opcion);
                    }
                    j++;
                }
                //Si la pregunta está respondida BIEN, muestro "Tilde" + "Opcion Correcta"
                //Leo contenido de cookie
                var cookie = $.cookie('respuestas_cookie');
                var arreglo = cookie.split(",");
                //busco el id que corresponde a la pregunta 
                var respondida = arreglo[i];
                console.log("respondida: " + respondida);
                if(respondida == '1')
                {
                    $('#respuestas').hide();
                    $('#div_responder').hide();
                    //leo id de respuesta correcta
                    var id_correcto = collection.at(i).get('respuesta');
                    //busco en las opciones
                    _.each(coleccion_opciones.models, function prueba(opcion){
                        if(opcion.get('id') == id_correcto){
                            //Muestro opcion correcta
                            $('#contenido_respuesta_correcta').html('');
                            $('#contenido_respuesta_correcta').append(opcion.get('contenido_opcion'));
                            $('#mensaje_correcto').show();
                        }
                    });
                }
                else
                {
                    $('#mensaje_correcto').hide();
                    $('#respuestas').show();
                    $('#div_responder').show();
                    var lista = $('#respuestas', this.el);
                    lista.empty();
                    $("#plantilla_radio").tmpl(coleccion_opciones.toJSON()).appendTo(lista);
                    $('#respuestas').listview('refresh');
                }
            }
        }
        //guardo la posición de la próxima pregunta a mostrar
        this.options.posicion_pregunta = orden_hacia_adelante;
    },
    anterior: function(){
        //guardo en memoria la posicion de la pregunta actual, la decremento y 
        //la uso para filtrar de toda la coleccion de preguntas y obtener la pregunta anterior
        console.log("posicion_pregunta: " + this.options.posicion_pregunta);
        var orden_hacia_atras = this.options.posicion_pregunta;
        //primera pregunta empieza en posicion 1
        if(orden_hacia_atras > 1){
            orden_hacia_atras--; 
        }
        console.log("orden_hacia_atras: " + orden_hacia_atras);
        var i;
        for(i=0; i<8; i++){
            var posicion = collection.at(i).get('posicion');
            var respondida = i;
            if (posicion == orden_hacia_atras) {
                document.getElementById("contenido").innerHTML = collection.at(i).get('contenido');
                //Genero coleccion de opciones segun la pregunta
                //Las preguntas tienen un máximo de 5 respuestas posibles
                //Para cada pregunta, genero las 5 opciones
                //Las 5 opciones se guardan en 1 coleccion nueva
                var j = 1;
                var coleccion_opciones = new Preguntas();
                while(j<6) {
                    var nombre = "opcion" + j;
                    if(collection.at(i).get(nombre) != 'vacio') //si la opcion tiene algo
                    {
                        var opcion = new Pregunta({id: j, contenido_opcion: collection.at(i).get(nombre)});
                        coleccion_opciones.add(opcion);
                    }
                    j++;
                }
                //Si la pregunta está respondida BIEN, muestro "Tilde" + "Opcion Correcta"
                //Leo contenido de cookie
                var cookie = $.cookie('respuestas_cookie');
                var arreglo = cookie.split(",");
                //busco el id que corresponde a la pregunta 
                var respondida = arreglo[i];
                console.log("respondida: " + respondida);
                if(respondida == '1') {
                    $('#respuestas').hide();
                    $('#div_responder').hide();
                    //leo id de respuesta correcta
                    var id_correcto = collection.at(i).get('respuesta');
                    //busco en las opciones
                    _.each(coleccion_opciones.models, function prueba(opcion){
                        if(opcion.get('id') == id_correcto){
                            //Muestro opcion correcta
                                $('#contenido_respuesta_correcta').html('');
                                $('#contenido_respuesta_correcta').append(opcion.get('contenido_opcion'));
                                $('#mensaje_correcto').show();
                        }
                    });
                }
                else
                {
                    $('#mensaje_correcto').hide();
                    $('#respuestas').show();
                    $('#div_responder').show();
                    var lista = $('#respuestas', this.el);
                    lista.empty();
                    $("#plantilla_radio").tmpl(coleccion_opciones.toJSON()).appendTo(lista);
                    $('#respuestas').listview('refresh');
                }
            }
        }
        //guardo la posición de la próxima pregunta a mostrar
        this.options.posicion_pregunta = orden_hacia_atras;
    },
    responder: function(){
        //capturo valor del radio-button seleccionado
        for (var i=0; i < document.respuestas.opciones.length; i++){
            if (document.respuestas.opciones[i].checked){
              var resp_elegida = document.respuestas.opciones[i].id;
            }
        }
        //obtengo respuesta correcta
        var correcta = collection.at(this.options.posicion_pregunta - 1).get('respuesta');
        console.log("posicion_pregunta: " + (this.options.posicion_pregunta - 1) + ", respuesta_correcta: " + correcta + ", respuesta_elegida: " + resp_elegida);
        var preg_actual = this.options.posicion_pregunta - 1;
        if(correcta == resp_elegida){
            $('#mensaje_error').hide();
            $('#respuestas').hide();
            $('#div_responder').hide();
            $('#mensaje_correcto').show();
            //muestro "Tilde" + Opcion correcta
            //leo id de respuesta correcta
            var id_correcto = collection.at(this.options.posicion_pregunta - 1).get('respuesta');
            //Genero las opciones para cada pregunta
            var coleccion_opciones = new Preguntas();
            var j = 0;
            while(j<6) {
                var nombre = "opcion" + j;
                if(collection.at(preg_actual).get(nombre) != 'vacio') //si la opcion tiene algo
                {
                    var opcion = new Pregunta({id: j, contenido_opcion: collection.at(preg_actual).get(nombre)});
                    coleccion_opciones.add(opcion);
                }
                j++;
            }
            //agregar respuesta correcta a $.cookie('respuestas_cookie');
            //voy guardando las preguntas BIEN contestadas
            var cookie = $.cookie('respuestas_cookie');
            var arreglo = cookie.split(",");
            arreglo[preg_actual] = '1';
            $.cookie('respuestas_cookie', arreglo);
            //sumo puntaje de la pregunta al puntaje total
            //Puntaje: Si respondés a la primera 10pts.
            // Si respondés al segundo intento 5 pts.
            // Si respondés luego de 3 o más intentos 1 pt.
            if(intento == 1){
                puntaje_total = puntaje_total + 10;
            }
            if(intento == 2){
                puntaje_total = puntaje_total + 5;
            }
            if(intento >= 3){
                puntaje_total = puntaje_total + 1;
            }
            intento = 1; //reseteo los intentos para la próx. pregunta
            console.log("intento: " + intento);
            $('#puntaje').html('');
            $('#puntaje').append(puntaje_total + " pts.");
            //Chequea si se respondieron todas las preguntas
            var x;
            var unos = 0;
            for(x = 0;x < 8; x++){
                if(arreglo[x] == '1'){
                    unos++;
                }
            }
            if(unos == 8){ //todas las preguntas respondidas
                setTimeout(function() {
                    window.location.href = "/#registrar_puntaje";
                }, 250);
            }
        }
        else
        {
            intento++;
            console.log("intento: " + intento);
            $('#mensaje_error').show();
            $('#respuestas').hide();
            //muestra mensaje de error por medio segundo, después muestra las opciones de nuevo
            setTimeout(function() {
                $('#mensaje_error').hide();
                console.log("preg_actual: " + preg_actual);
                    if(preg_actual == '7'){
                        $('#btn_anterior').click();
                        $('#btn_siguiente').click();
                    }
                    else
                    {
                        $('#btn_siguiente').click();
                        $('#btn_anterior').click();
                    }
                    $('#respuestas').show();
            },2000);
            // puntaje_total = puntaje_total - 5;
            $('#puntaje').html('');
            $('#puntaje').append(puntaje_total + " pts.");
        }
    }
});