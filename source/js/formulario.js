$(document).ready(function(){
	$.parse.init({
		app_id : 'F1iXn056CKTE2k4RUMZeiLkaoWC9geoKsKKeMeYd', // <-- enter your Application Id here 
		rest_key : 'zjeGNFeqTB8XuXhcrVDdfkInx8656DAnDcfR0Nr8' // <--enter your REST API Key here	
	});

	$('#btn_terminar').click(function(){
		$.cookie('respuestas_cookie', null);
		puntaje_total = 0;
		window.location.reload();
	});

	//Cargo resultados en tabla Puntajes
	$('#btn_registrar').click(function(){
		if($('#user').val() == ''){
			alert("Debe ingresar un nombre");
		}
		else
		{
			var p = {username: $('#user').val(), email: $('#mail').val(), puntaje: puntaje_total, password: '123456'};
			$.cookie('respuestas_cookie', null);
			puntaje_total = 0;
			$.parse.post('users', p, function(json){
				if(json.sessionToken != null){
					console.log("valor de sessionToken: " + json.sessionToken);
					alert("Datos cargados correctamente");
					$('#btn_lista_puntajes').click();
				}
			});
		}
	});
	
	//GET de usuarios registrados
	$('#btn_users').click(function(){
		$.parse.get("users", function(json){
			var results = json.results;
			results.forEach(function(user){
				console.log("user: " + user.username);
			});
		});
	});

	//GET pregunta en particular
	$('#btn_carga').click(function(){
		$.parse.get("users", function(json){
			var results = json.results;
			results.forEach(function(user){
				if(user.id_pregunta == '5'){
					console.log("cargo la pregunta con id 5");
					console.log("id: " + user.id_pregunta + " ,contenido: " + pregunta.contenido + ", respuesta: " + pregunta.respuesta);
				}
			});
		});
	});
});

