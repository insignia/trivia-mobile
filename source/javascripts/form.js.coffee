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
  
