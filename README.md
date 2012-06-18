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


Pasos para subir esta app a heroku http://www.heroku.com/

1) Exportar el sitio estático 
En la consola escribir:
$ cd trivia-mobile (Ir al directorio trivia-mobile)
$ trivia-mobile> middleman build
Esto creará una carpeta llamada build con los archivos y proyectos de la app.

2) Cambiar el nombre de la carpeta build por public 

3) Crear archivo con el nombre config.ru y agregar:

use Rack::Static, 
  :urls => ["/stylesheets", "/images", "/javascripts"],
  :root => "public"

run lambda { |env|
  [
    200, 
    {
      'Content-Type'  => 'text/html', 
      'Cache-Control' => 'public, max-age=86400' 
    },
    File.open('public/index.html', File::RDONLY)
  ]
}

4) Crear archivo con el nombre Gemfile y agregar
source 'https://rubygems.org'
gem 'rails', '3.2.3'

5) Crear archivo Gemfile.lock
En la consola escribir:
$ cd trivia-mobile (Ir al directorio trivia-mobile)
$ bundle install 

La estructura de su sitio quedaría como
trivia-mobile
- config.ru
- carpeta: public
	- index.html 
	- carpeta: stylesheets
	- carpeta: images
	- carpeta: javascripts
- Gemfile
- Gemfile.lock

6) Login en heroku (Debe estar registrado previamente)
En la consola escribir:
> heroku login
Ingresar su email y password

7) Crear app en heroku
En la consola escribir:
> heroku create --stack cedar app_nombre (Debe ser diferente a trivia-mobile que ya existe)

8) Configurar a que app se subirán archivos:
En la consola escribir:
$ cd trivia-mobile (Ir al directorio trivia-mobile)
$ git init
$ git remote add heroku git@heroku.com:app_nombre.git

9) Subir archivos a heroku:
En la consola escribir:
> git add .
> git commit -m "Comentario"
> git push heroku master

10) Abrir el navegador e ir a http://app_nombre.herokuapp.com/ para vizualizar la app subida en heroku
