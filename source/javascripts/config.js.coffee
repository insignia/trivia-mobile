click_en_boton_pregunta = '0'
click_en_boton_registrar = '0'
window.click_lista_puntajes = '0'
window.puntaje_total = 0
window.intento = 1

class window.msj    
    @mensajes = (me,mc,dr,re,hc,hs) ->
        if me is '0' then $('#mensaje_error').hide() else $('#mensaje_error').show()
        if mc is '0' then $('#mensaje_correcto').hide() else $('#mensaje_correcto').show()
        if dr is '0' then $('#div_responder').hide() else $('#div_responder').show()
        if re is '0' then $('#respuestas').hide() else $('#respuestas').show()
        if hc is '0' then $('#header_con_botones').hide() else $('#header_con_botones').show()
        if hs is '0' then $('#header_sin_botones').hide() else $('#header_sin_botones').show()

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
    $('#puntaje').html('')
    $('#puntaje').append(window.puntaje_total + " pts.")
    msj.mensajes('0','0','0','0','1','0')
    $('#btn_pregunta').click ->
        arreglo_correctas = new Array('0','0','0','0','0','0','0','0')
        $.cookie('respuestas_cookie', arreglo_correctas)
        click_en_boton_pregunta = '1'
        vista = new window.VistaPreguntas
    $("#loading").ajaxStart ->
        $("#loading").show()
    $("#loading").ajaxStop ->
        if click_en_boton_pregunta is '1'
            msj.mensajes('0','0','1','0','1','0')
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
