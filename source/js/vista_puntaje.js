Puntaje = Backbone.Model.extend({
     initialize: function(){
        _.bindAll(this, 'remove');
     },
     remove: function(){
        this.destroy();
     }
});

Puntajes = Backbone.Collection.extend({
    model: Puntaje,
    comparator: function(item){
        //a medida que se van agregando preguntas a la coleccion, se ordenan de forma ascendente por id.
        return -item.get("puntaje"); 
     },
});

Vista_puntaje = Backbone.View.extend({
    el: $('#registrar_puntaje'), //elemento del DOM que contiene todo lo referido a la vista (boton, ul, li), es el ID de la seccion TimeEntries
    events: {
            'click a#btn_lista_puntajes': 'lista_puntaje' //Genero la lista de puntajes
    },
    initialize: function(){
        _.bindAll(this, 'lista_puntaje');
        $.parse.init({
             app_id : 'F1iXn056CKTE2k4RUMZeiLkaoWC9geoKsKKeMeYd', // <-- enter your Application Id here 
             rest_key : 'zjeGNFeqTB8XuXhcrVDdfkInx8656DAnDcfR0Nr8' // <--enter your REST API Key here    
         });
    },
    lista_puntaje: function(){
        //hacer un GET de la tabla "users" y mostrar los 10 primeros puestos
        click_lista_puntajes = '1';
        $.parse.get("users", function(json){
            lista_puntajes_completa = new Puntajes();
            var results = json.results;
            //Primero obtengo todos los usuarios
            results.forEach(function(user){
                var name = user.username;
                var email = user.email;
                var puntaje = user.puntaje;
                console.log(name + " - email: " + email + " - " + puntaje + " pts.");
                var item = new Puntaje({name: name, email: email, puntaje: puntaje});
                lista_puntajes_completa.add(item);
                //Renderizo listado de users y hago el refresh en el callback de la llamada AJAX: AjaxStop() ---> head.erb
            });
            //Ahora obtengo los 10 primeros
            lista_puntajes = new Puntajes();
            var total = 0;
            _.each(lista_puntajes_completa.models, function (a){
                if(total < 10){
                    var punto = new Puntaje({name: a.attributes.name, email: a.attributes.email, puntaje: a.attributes.puntaje});
                    lista_puntajes.add(punto);
                    total++;
                    // console.log(a.attributes.puntaje);
                }
            });
        });
    }
});

var tabla_puntajes = new Vista_puntaje();