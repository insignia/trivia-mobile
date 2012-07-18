$(document).ready ->
  $('#btn_terminar').click ->
    $.cookie 'respuestas_cookie', null
    window.puntaje_total = 0
    window.location.reload()

  #Se puede hacer desde la vista de puntajes
  $('#btn_registrar').click ->
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
  
  #No existe btn_users ni btn carga    
  #$('#btn_users').click -> 
  #  $.parse.get "users", (json) ->
  #    results = json.results;
  #    results.forEach (user) ->
  #      console.log "user: " + user.username

  #$('#btn_carga').click ->
  #  $.parse.get "users", (json) ->
  #    results = json.results
  #    results.forEach (user) ->
  #      if user.id_pregunta is '5' 
  #        console.log "cargo la pregunta con id 5"
  #        console.log "id: " + user.id_pregunta + " ,contenido: " + pregunta.contenido + ", respuesta: " + pregunta.respuesta
