App trivia-mobile http://trivia-mobile.herokuapp.com/
=====================================================

Los requisitos previos: 
Debe tener instalado ruby 1.87 -p 352 y rails 2.3

Pasos para poner en funcionamiento la app trivia-mobile:

1) Instalar Middleman (Middleman es una herramienta de línea de comandos para la creación de páginas web estáticas para más información visitar http://middlemanapp.com/)
Ir a la consola de comandos y escribir: 
$ gem install middleman
Esto instalará Middleman, sus dependencias y las herramientas de línea de comandos para su uso.
Este proceso agregará un nuevo comando, con 3 funciones útiles:
-	middleman init
-	middleman server
-	middleman build

2) Iniciar el servidor de middleman:
En la consola escribir:
$ cd trivia-mobile (Ir al directorio trivia-mobile)
$ trivia-mobile > middleman server –p 4567 

3) Abrir el navegador e ir a localhost/4567 para vizualizar la app.



