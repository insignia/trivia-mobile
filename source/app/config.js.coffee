click_en_boton_pregunta = '0'
click_en_boton_registrar = '0'
window.click_lista_puntajes = '0'
window.puntaje_total = 0
window.intento = 1

class window.Mensajes
    @deshabilita_todo: ->
        $('#mensaje_error').hide()
        $('#mensaje_correcto').hide()
        $('#div_responder').hide()
        $('#respuestas').hide()
    @habilita_respcorrecta: ->
        $('#mensaje_error').hide()
        $('#mensaje_correcto').show()
        $('#div_responder').hide()
        $('#respuestas').hide()
    @habilita_respincorrecta: ->
        $('#mensaje_error').show()
        $('#mensaje_correcto').hide()
        $('#div_responder').hide()
        $('#respuestas').hide()
    @habilita_respuestas: ->
        $('#mensaje_error').hide()
        $('#mensaje_correcto').hide()
        $('#div_responder').show()
        $('#respuestas').show()

@muestra_puntaje = ->
    $('#puntaje').html(window.puntaje_total + " pts.")

@muestra_lista_puntajes = ->
    $('#lista_puntos').empty()
    $("#plantilla_lista_puntaje").tmpl(window.lista_puntajes.toJSON()).appendTo($('#lista_puntos'))
    $('#lista_puntos').listview('refresh')

$(document).ready ->
    window.location.href = "/#page1"
    windowWidth = $(window).width()
    windowHeight = $(window).height()
    if windowWidth <= 400  
    	$('div #imagen_preguntas').resize({
    		maxWidth: 100,
    		maxHeight: 150})
    if windowWidth > 400 and windowWidth <= 1000
        $('div #imagen_preguntas').resize({
            maxWidth: 400,
            maxHeight: 150})
    window.puntaje_total = 0
    muestra_puntaje()
    $('#header_con_botones').show()
    $('#header_sin_botones').hide()
    Mensajes.deshabilita_todo()
    $('#btn_pregunta').click ->
        $.cookie 'respuestas_cookie', ['0','0','0','0','0','0','0','0']
        click_en_boton_pregunta = '1'
        vista = new window.VistaPreguntas
    $("#loading").ajaxStart ->
        $("#loading").show()
    $("#loading").ajaxStop ->
        if click_en_boton_pregunta is '1'
            $('#btn_siguiente').click()
            click_en_boton_pregunta = '0'
        if click_en_boton_registrar is '1'
            click_en_boton_registrar = '0'
            alert "Datos cargados correctamente"
            $('#user').val('')
            $('#email').val('')
            window.puntaje_total = 0
            muestra_lista_puntajes()
            window.location.href = "/#lista_puntajes"
        if window.click_lista_puntajes is '1'
            muestra_lista_puntajes()
            click_lista_puntajes = '0'
        $("#loading").hide()
    $('#btn_terminar').click ->
        $.cookie 'respuestas_cookie', null
        window.puntaje_total = 0
        window.location.reload()
