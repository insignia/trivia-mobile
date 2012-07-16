# [App trivia-mobile][url]

**Descripción:** Esta aplicación muestra una serie de preguntas y nos permite selccionar una respuesta. Si en el primer intento la respuesta ingresada es correcta tendrá un puntaje de 10 pts., si en el segundo intento la respuesta ingresada es correcta tendrá un puntaje de 5 pts. y luego del tercer intento la respuesta tendrá un puntaje de 1 pt. Al finalizar el cuestionario podrá registrar su puntaje ingresando su Nombre y Correo que quedará guardado en la base de datos y además podrá vizualizar la tabla de los mejores puntajes.

Para la construcción de esta aplicación se usaron [jquery-mobile][urljmobile], [jquery][urljquery], [middleman][urlMiddleman], [parse][urlParse], [backbone.js][urlbackbone] y [coffeescript][urlcoffee].

### Los requisitos previos: 

- **Debe tener instalado ruby 1.8.7 y git**


### Pasos para poner en funcionamiento la app trivia-mobile:

1) Clonar el repositorio. Ir a la consola de comandos y escribir:

	git clone git@github.com:insignia/trivia-mobile.git

2) Para instalar todo lo necesario para su funcionamiento, debe estar dentro del directorio trivia-mobile clonado anteriormente y en la consola escribir:

	cd trivia-mobile 
	bundle install 

3) Crear una cuenta en [Parse][urlParse] 

4) Crear una app en Parse con cualquier nombre, luego ir a Dashboard y seleccionar la app creada anteriormente.

5) Ir a Data Browser y elegir la opción Import existing data from a CSV file. En Name of new class poner preguntas_oficiales, seleccionar archivo preguntas_oficiales.txt que se encuentra en la carpeta de trivia-mobile y luego Import. Por último seleccionar los siguientes tipos de datos para cada campo:
- **Contenido:** string
- **Opcion1:** string
- **Opcion2:** string
- **Opcion3:** string
- **Opcion4:** string
- **Opcion5:** string
- **Posicion:** number
- **Respuesta:** string

Al hacer esto se creará una tabla con los datos de las preguntas de la app.

6) Copiar los valores que figuran en ***Application ID*** y ***REST API Key*** de su cuenta de Parse.

7) Hacer una copia del archivo settings.yml.sample y con el nombre de settings.yml. En la consola escribir:

	cp data/settings.yml.sample data/settings.yml

8) Con los valores ***Application ID*** y ***REST API Key*** de su cuenta de Parse pegarlos en el archivo settings.yml creado anteriormente en la siguiente parte del código: 

```yaml
parse:
  	app_id: your-parse-app-id
  	rest_api_key: your-parse-rest-api-key
	
```
Luego guardar los cambios en el archivo.

9) Para iniciar el servidor de [middleman][urlMiddleman] debe estar dentro del directorio trivia-mobile y en la consola escribir:

	middleman server -p 4567

**Nota:** El número 4567 es el puerto puede utilizar otro número si lo desea.

10) Finalmente ir al navegador web y escribir localhost:4567 para probar la aplicación.

[url]: http://trivia-mobile.herokuapp.com/
[urlParse]: https://parse.com/
[urlMiddleman]: http://middlemanapp.com/
[urlbackbone]: http://backbonejs.org/
[urlcoffee]: http://coffeescript.org/
[urljmobile]: http://jquerymobile.com/
[urljquery]: http://jquery.com/
