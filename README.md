### Universidad ORT Uruguay
#### Facultad de Ingeniería



# Certificación DevOps

El siguiente documento registra el proceso de análisis, diseño e implementación de una solución para la tarea obligatoria del taller de DevOps de la carrera de Analista en Tecnologías de la Información de la Universidad ORT Uruguay.

# 1. Introducción

El siguiente capítulo presenta la planificación y propuesta de implantación de un método de trabajo DevOps en una empresa líder en retail. A raíz de los problemas que experimenta la empresa debido a su rápido crecimiento, se propone una transición a un método de trabajo que asegure una mayor calidad en sus procesos de desarrollo y entrega de valor a sus clientes.

## 1.1. Presentación del problema

Una empresa de retail líder en el mercado experimenta actualmente problemas de diversa índole, debido al rápido crecimiento que ha experimentado y la integración de nuevas tecnologías. Por estas razones, ha crecido la descoordinación de los diversos equipos encargados de hacer la entrega de un producto de valor al cliente final, así como también el producto entregado sufre constantes problemas de estabilidad y disponibilidad.

###   1.1.1 La descoordinación entre equipos

Existe actualmente una descoordinación entre los objetivos del equipo de desarrollo, el cual se concentra principalmente en el rápido desarrollo de funcionalidades al costo de dejar de lado otras consideraciones ajenas al dominio del desarrollo propiamente dicho. Esto genera, en forma frecuente, impactos inesperados en la infraestructura y la experiencia de usuario.

###   1.1.2. El desafío de las nuevas tecnologías

La incorporación de nuevas tecnologías y nuevas formas de trabajo han generado inestabilidad en los distintos ambientes de desarrollo y pruebas, provocando errores inesperados de difícil solución dentro de una nueva cultura de trabajo que la organización quiere integrar.

###   1.1.3. La inestabilidad del sistema

Los problemas anteriores terminan provocando que la empresa sea incapaz de ofrecer un servicio 100% fiable a sus usuarios finales, pues está sujeta a variables que no puede predecir en el estado actual de desorden que se encuentra a raíz de su cambio en la forma de trabajo y las tecnologías empleadas.

## 1.2. Listas de necesidades

La empresa de retail necesita abordar la causa profunda de raíz e incorporar una estrategia que le permita superar los problemas antes detallados y así lograr una entrega de valor al cliente que sea fiable, de fácil mantenimiento y versátil para adaptarse al cambio.

1. Se necesita incorporar un método de trabajo que permita que cada equipo pueda trabajar en la entrega de valor al producto, aunque de una manera ordenada,  predecible y en un entorno controlable.
2. Se necesita implementar una método de entrega de valor continuo, que se adapte a las nuevas tecnologías que está incorporando la empresa, sin que esto vaya en detrimento de la calidad del producto entregado y la capacidad de trabajo de cada equipo.
3. Se necesita implantar un método de trabajo que permita conectar áreas de trabajo y equipo que actualmente no trabajan en forma integrada, para que los errores y obstáculos surjan tempranamente en el proceso y se puedan resolver en forma efectiva y eficaz.

## 1.3. Solución planteada

La propuesta de este equipo es dirigir a la empresa hacia la adopción progresiva de un método de trabajo DevOps, es decir, uno que permita integrar áreas de trabajo y equipos que se encuentran trabajando en forma separada actualmente. Para lograr esto se busca atacar los problemas desde diferentes áreas:

1. Migrar a una  arquitectura de microservicios que permita a equipos pequeños de desarrolladores concentrarse en pequeñas porciones del producto sobre las que puedan incorporar nuevo valor en forma de funcionalidades para el cliente final.
2. Integrar a los equipos de desarrollo, testing y operaciones a través de ciclos de integración y despliegue continuos, donde cada ciclo involucre a los diferentes actores para detectar posibles problemas en forma frecuente y temprana.
3. Migrar la infraestructura a la nube con un proveedor que permita el despliegue del producto final en forma fiable y robusta, para dar estabilidad al sistema y sea predecible para los distintos equipos involucrados en el desarrollo, prueba y despliegue del producto.

###   1.3.1. La arquitectura de microservicios

Como se detalló antes, parte de la solución radica en compartimentar el desarrollo del producto con una lógica que permita a pequeños equipos trabajar en forma eficiente en la entrega de valor para el cliente final. En este sentido, se propone a la empresa adoptar una arquitectura orientada a microservicios, pues este enfoque permitirá acotar el alcance del trabajo de cada equipo, minimizando solapamientos y retrabajos entre los diferentes equipos.

###   1.3.2. La infraestructura en la nube

Se determinó una infraestructura que, en términos generales, según el diagrama, cuenta con:

1. Una VPC para encapsular todos los recursos en la nube.
2. Una API Gateway para disponibilizar los recursos en la nube hacia Internet.
3. Cuatro balanceadores de carga tipo aplicación, cada uno conectado a un microservicio.
4. Dos subnets, donde se localizan los microservicios que, en conjunto con el ALB proveen mayor disponibilidad a los microservicios.
5. Un cluster ECS donde se define a se vez:
    a. Cuatro tareas: cada una define una imagen de un contenedor desde un repositorio en Docker Hub.
    b. Cuatro servicios: cada uno implementa una de las tareas en un contenedor donde corre cada microservicio.

![Diagrama de infraestructura](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/infra.png)

####   1.3.3. Control de versiones y repositorios

Se empleará GitHub para disponibilizar un repositorio por cada microservicio que desarrolla el equipo de backend, otro para el equipo de frontend y otro para el equipo de operaciones. De esta forma, cada equipo definirá interfaces claras para interactuar con sus piezas del producto y podrá hacer su servicio accesible al resto como servicio web RESTful. El frontend, sobre el que impactan decisiones de diseño, UI/UX (user interface y user experience, respectivamente), entre otros, tiene un ciclo de vida diferente a, por ejemplo, los microservicios del backend, por lo que, al separar cada equipo y su porción de software en el que trabajar, podrán concentrarse en el desarrollo de la solución de los problemas concretos de su dominio y colaborar más eficazmente en aquellas partes comunes.

#####     1.3.3.1. Flujos de trabajo: trunk based y gitflow

Para atacar los problemas de la organización e impulsar la metodología DevOps en la empresa, se propone separar cada microservicio en un repositorio disponible para cada equipo de desarrollo respectivamente. La infraestructura que se propone, implementada como código a través de Terraform, se trabajaría con una práctica de gestión de versiónes tipo trunk based, ya que simplifica las fases de fusión e integración. Esta práctica consiste en la creación de ramas de corta duración, sobre la que un pequeño grupo de desarrolladores trabaja en features que luego integra en una rama principal. Las confirmaciones también son más breves, por lo que el desarrollo de la infraestructura y la disponibilización de recursos de cómputo será más ágil que en un práctica de Gitflow.

![Diagrama de trunkbased](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/trunbkbased.png)

Por otro lado, se propone emplear GitFlow como práctica para el desarrollo de los demás componentes a desarrollar, a saber: el backend y el frontend. Se propone GitFlow pues permite desarrollar un producto que se puede ajustar ciclos de publicación programados, que necesitan varias confirmaciones y que necesitan pasar por varios procesos de validación antes de ser entregados al cliente en producción.

![Diagrama de gitflow](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/gitflow.png)
