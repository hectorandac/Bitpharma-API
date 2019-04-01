# bitpharma-api
[![Build Status](https://travis-ci.com/notbaddays/bitpharma-api.svg?branch=master)](https://travis-ci.com/notbaddays/bitpharma-api) 

# Welcome to Rails

## What's Rails?

Rails es un marco de aplicación web que incluye todo lo necesario para
crear aplicaciones web respaldadas por bases de datos de acuerdo con la
[Model-View-Controller (MVC)](https://en.wikipedia.org/wiki/Model-view-controller)
modelo.

Comprender el patrón MVC es clave para entender Rails. MVC divide tu
Aplicación en tres capas: Modelo, Vista y Controlador, cada uno con una responsabilidad específica.

## Model layer

La _**Capa del modelo**_ representa el modelo de dominio (como Cuenta, Producto,
Persona, Publicación, etc.) y encapsula la lógica de negocios específica de
tu solicitud. En Rails, las clases de modelos respaldadas por bases de datos se derivan de `ActiveRecord::Base`. [Registro activo](activerecord/README.rdoc) le permite presentar los datos de Las filas de la base de datos como objetos y embellecen estos objetos de datos con lógica empresarial.

Aunque la mayoría de los modelos de Rails están respaldados por una base de datos, los modelos también pueden ser ordinarios. Clases de Ruby, o clases de Ruby que implementan un conjunto de interfaces como lo proporciona el módulo [Modelo activo](módulo de activación/README.rdoc).

## Controller layer

La _**capa de controlador**_ es responsable de manejar las solicitudes HTTP entrantes. Proporcionando una respuesta adecuada. Normalmente esto significa devolver HTML, pero los controladores de Rails. También puede generar XML, JSON, PDF, vistas específicas de dispositivos móviles y más. Los controladores de carga y
manipule los modelos y renderice las plantillas de vista para generar la respuesta HTTP adecuada. En Rails, las solicitudes entrantes son enviadas por Action Dispatch a un controlador apropiado, y las clases del controlador se derivan de `ActionController::Base`. Despacho de acción y controlador de acción.

## View layer

La _**Capa de vista**_ se compone de "plantillas" que se encargan de proporcionar. Representaciones apropiadas de los recursos de su aplicación. Las plantillas pueden venir en una variedad de formatos, pero la mayoría de las plantillas de vista son HTML con incrustado. Código rubí (archivos ERB). Las vistas normalmente se representan para generar una respuesta del controlador.

## Getting Started

1. Install Rails at the command prompt if you haven't yet:

        $ gem install rails

2. At the command prompt, create a new Rails application:

        $ rails new myapp

   where "myapp" is the application name.

3. Change directory to `myapp` and start the web server:

        $ cd myapp
        $ rails server

   Run with `--help` or `-h` for options.

4. Go to `http://localhost:3000` and you'll see:
"Yay! You’re on Rails!"

5. Follow the guidelines to start developing your application. You may find
   the following resources handy:
    * [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html)
    * [Ruby on Rails Guides](https://guides.rubyonrails.org)
    * [The API Documentation](https://api.rubyonrails.org)
    * [Ruby on Rails Tutorial](https://www.railstutorial.org/book)

## Expresiones de gratitud

Agradecemos a los autores de los proyectos relacionados existentes por sus ideas y colaboración:

- [@carlosvq](https://github.com/carlosvq)
- [@ricardomalagon](https://github.com/ricardomalagon)
- [@visquel](https://github.com/visquel)
- [@leinadpb](https://github.com/leinadpb)
- [@hectorandac](https://github.com/hectorandac)

## License

Este software es open source, [licensed as MIT](https://github.com/facebook/create-react-app/blob/master/LICENSE).
