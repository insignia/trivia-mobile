click_en_boton_pregunta = '0'
click_en_boton_registrar = '0'
window.click_lista_puntajes = '0'
window.puntaje_total = 0
window.intento = 1

$(document).ready ->
    window.location.href = "/#page1"
    windowWidth = $(window).width()
    windowHeight = $(window).height()
    console.log "windowWidth es: " + windowWidth
    console.log "windowHeight es: " + windowHeight
    if windowWidth <= 400  
    	$('div #imagen_preguntas').resize({
    		maxWidth: 100,
    		maxHeight: 150})
    if windowWidth > 400 and windowWidth <= 1000
        $('div #imagen_preguntas').resize({
            maxWidth: 400,
            maxHeight: 150})
    window.puntaje_total = 0
    $('#puntaje').html('')
    $('#puntaje').append(window.puntaje_total + " pts.")
    $('#mensaje_error').hide()
    $('#mensaje_correcto').hide()
    $('#div_responder').hide()
    $('#header_con_botones').show()
    $('#header_sin_botones').hide()
    $('#btn_pregunta').click ->
        arreglo_correctas = new Array('0','0','0','0','0','0','0','0')
        $.cookie('respuestas_cookie', arreglo_correctas)
        console.log "contenido respuestas_cookie: " + $.cookie('respuestas_cookie')
        click_en_boton_pregunta = '1'
        vista = new window.Vista_preguntas
    $("#loading").ajaxStart ->
        $("#loading").show()
        console.log "Empieza llamada Ajax" 
    $("#loading").ajaxStop ->
        if click_en_boton_pregunta is '1'
            console.log "pregunta 1"
            $('#div_responder').show()
            $('#btn_siguiente').click()
            click_en_boton_pregunta = '0'
        if click_en_boton_registrar is '1'
            click_en_boton_registrar = '0'
            alert "Datos cargados correctamente"
            $('#user').val('')
            $('#email').val('')
            window.puntaje_total = 0
            lista = $('#lista_puntos')
            lista.empty()
            $("#plantilla_lista_puntaje").tmpl(window.lista_puntajes.toJSON()).appendTo(lista)
            $('#lista_puntos').listview('refresh')
            window.location.href = "/#lista_puntajes"
        if window.click_lista_puntajes is '1'
            lista = $('#lista_puntos')
            lista.empty()
            $("#plantilla_lista_puntaje").tmpl(window.lista_puntajes.toJSON()).appendTo(lista)
            $('#lista_puntos').listview('refresh')
            click_lista_puntajes = '0'
        $("#loading").hide()
        console.log "Termina llamada Ajax"
                               