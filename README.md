# [App trivia-mobile][url]

**Descripción:** Esta aplicación muestra una serie de preguntas y nos permite selccionar una respuesta. Si en el primer intento la respuesta ingresada es correcta tendrá un puntaje de 10 pts., si en el segundo intento la respuesta ingresada es correcta tendrá un puntaje de 5 pts. y luego del tercer intento la respuesta tendrá un puntaje de 1 pt. Al finalizar el cuestionario podrá registrar su puntaje ingresando su Nombre y Correo que quedará guardado en la base de datos y además podrá vizualizar la tabla de los mejores puntajes.

Para la construcción de esta aplicación se usaron jquery-mobile, jquery, middleman, Parse, backbone.js y coffeescript.

### Los requisitos previos: 

- **Debe tener instalado ruby 1.8.7 y git**

### Pasos para poner en funcionamiento la app trivia-mobile:

1) Clonar el repositorio
Ir a la consola de comandos y escribir:

	git clone git@github.com:insignia/trivia-mobile.git

2) Instalar todo lo necesario para su funcionamiento
En la consola escribir:

	cd trivia-mobile (Ir al directorio trivia-mobile clonado anteriormente)
	bundle install 

3) Crear una cuenta en [Parse][urlParse] 

4) Crear una app en Parse con cualquier nombre, luego ir a Dashboard y seleccionar la app creada anteriormente.

5) Copiar los valores que figuran en Application ID y REST API Key de su cuenta de Parse y pegarlos en los archivos vpreguntas.js.coffee y vpuntajes.js.coffee en la siguiente parte del código: 

	init('Application ID','REST API Key')

En vpreguntas.js.coffee línea 9
En vpuntajes.js.coffee línea 7

Su código debe quedar de la siguiente manera pero con sus valores de Application ID y REST API Key. 
Ejemplo: init('mJDSHSMJbdXm1GtLsTsGhXDvqn63RER6HL23JXTCG','ubpbA8Q1gplTRybw6pTkDAoZsT8KZTI9cy2tKJ82')

**Los archivos vpreguntas.js.coffee y vpuntajes.js.coffee se encuentran en trivia-mobile/source/app/view**

6) Ir a Data Browser y elegir la opción Import existing data from a CSV file. En Name of new class poner preguntas_oficiales, seleccionar archivo preguntas_oficiales.txt que se encuentra en la carpeta de trivia-mobile y luego Import. Por último seleccionar los siguientes tipos de datos para cada campo:
- Contenido: string
- Opcion1: string
- Opcion2: string
- Opcion3: string
- Opcion4: string
- Opcion5: string
- Posicion: number
- Respuesta: string

Al hacer esto se creará una tabla con los datos de las preguntas de la app.

7) Iniciar el servidor de middleman
En la consola escribir:

	cd trivia-mobile (Debe estar en el directorio trivia-mobile)
	middleman server -p 4567

8) Finalmente ir al navegador web y escribir localhost:4567 para probar la aplicación.

[url]: http://trivia-mobile.herokuapp.com/
[urlParse]: https://parse.com/ 