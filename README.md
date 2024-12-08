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

### 1.3.2. Integración y despliegue continuos

Parte del problema de la organización es la falta de trabajo integrado de varios de los equipos de desarrollo. Se propone diseñar un pipeline de trabajo que permita integrar, construir, probar y desplegar continuamente los nuevos cambios incorporados por cada equipo. De esta manera se logrará detectar en forma temprana las posibles fallas del sistema, fallas de integración y usabilidad al tiempo que permita entregar valor en forma constante a los clientes. 

Se propone, en el pipeline de integración:

1. Construir la aplicación para poder ejecutar pruebas sobre ella antes del despliegue a producción.
2. Probar cada endpoint de los microservicios utilizando Postman para verificar que la aplicación responde como se espera.
3. Analizar la calidad del código entregado empleando SonarCloud para detectar errores y defectos en él.
4. Construir el contenedor a desplegar en producción.
5. Subir la imagen del contenedor probado a un repositorio de Docker Hub, desde donde los servicios de Elastic Container Service la tomará para construir los servicios.

![Diagrama de integración y despliegue continuos](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/CICD.png)

#### 1.3.2.1. El funcionamiento del pipeline

Para hacer esta integración se empleará Github Actions, donde se definirá el pipeline de integración.

En el primer paso, **Set up JDK 17 and build**, se instalan las dependencias necesarias para poder construir la imagen. Tras eso, el paso **Endpoint testing via Newman/Postman**, instala las dependencias para poder testear los endpoints del microservicio con Newman/Postman y se realizan los tests. De esta manera, se verifica que la aplicación se comporta como se espera incluso tras sufrir adiciones o sustracciones en el código.

Una vez  probada la aplicación en funcionamiento, se analiza el código estáticamente para detectar posibles fallas y malas prácticas en el paso **Static code analysis w/ Sonar  Cloud**:

![Screenshot SonarCloud project dashboard](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/evidencia/pipeline/sonarcloud.png)

Como se puede observar, en el caso del microservicio de productos, no existen puntos a mejorar de acuerdo al análisis de SonarCloud:

![Screenshot SonarCloud project dashboard](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/evidencia/pipeline/sonarcloud_products_passed_tests.png)

Sin embargo, al correr los análisis sobre el código del microservicio de órdenes, se puede observar cómo ese análisis detecta justamente uno de los problemas por los cuales este microservicio no puede funcionar sin los demás. Es decir, el análisis de código estático detecta el acoplamiento entre estos servicios, pues ell error NullPointerException se arroja justamente cuando las órdenes no pueden acceder a los productos.

![Screenshot SonarCloud project dashboard](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/evidencia/pipeline/sonarcloud_orders_failed_tests.png)

Finalmente, se contruye la imagen del contenedor probado en los pasos **Build Docker container** y **Push Docker image**:

![Diagrama de infraestructura](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/dockerhub.png)

Una vez en el repositorio de **Docker Hub**, el **Elastic Container Service** en AWS podrá construir y deplegar el servicio y dejarlo disponible a Internet a través de una API pública implementada con **API Gateway**.

###   1.3.3. La infraestructura en la nube

Se determinó una infraestructura que, en términos generales, según el diagrama, cuenta con:

1. Una VPC para encapsular todos los recursos en la nube.
2. Una API Gateway para disponibilizar los recursos en la nube hacia Internet.
3. Cuatro balanceadores de carga tipo aplicación, cada uno conectado a un microservicio.
4. Dos subnets, donde se localizan los microservicios que, en conjunto con el ALB proveen mayor disponibilidad a los microservicios.
5. Un cluster ECS donde se define a se vez:
    a. Cuatro tareas: cada una define una imagen de un contenedor desde un repositorio en Docker Hub.
    b. Cuatro servicios: cada uno implementa una de las tareas en un contenedor donde corre cada microservicio.

![Diagrama de infraestructura](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/infra.png)

#### 1.3.3.1. Terraform: infraestructura como código

Para implementar la infraestructura se propone mantener una sola fuente de verdad para determinar los recursos que la organización dispone para ofrecer sus servicios a los clientes. Terraform permite en forma declarativa definir qué recursos en la nube se dispondrán y con qué configuraciones se deben iniciar. De esta manera, a través de una sola herramienta el equipo de infraestructura puede lanzar recursos para diferentes espacios: el de desarrollo, el código productivo y el de testeo.

Para lograr el manejo de diferentes ambientes se deben emplear diferentes workspaces, pues cada recurso en main.tf está prefijado con la variable terraform.workspace para distinguir los recursos de cada ambiente por un nombre único. Para lanzar el ambiente de testing bastaría con ejecutar __terraform worskpace select testing__ y con ello Terraform rastrearía el estado de los recursos para ese ambiente.

####   1.3.3. Control de versiones y repositorios

Se empleará GitHub para disponibilizar un repositorio por cada microservicio que desarrolla el equipo de backend, otro para el equipo de frontend y otro para el equipo de operaciones. De esta forma, cada equipo definirá interfaces claras para interactuar con sus piezas del producto y podrá hacer su servicio accesible al resto como servicio web RESTful. El frontend, sobre el que impactan decisiones de diseño, UI/UX (user interface y user experience, respectivamente), entre otros, tiene un ciclo de vida diferente a, por ejemplo, los microservicios del backend, por lo que, al separar cada equipo y su porción de software en el que trabajar, podrán concentrarse en el desarrollo de la solución de los problemas concretos de su dominio y colaborar más eficazmente en aquellas partes comunes.

#####     1.3.3.1. Flujos de trabajo: trunk based y gitflow

Para atacar los problemas de la organización e impulsar la metodología DevOps en la empresa, se propone separar cada microservicio en un repositorio disponible para cada equipo de desarrollo respectivamente. La infraestructura que se propone, implementada como código a través de Terraform, se trabajaría con una práctica de gestión de versiónes tipo trunk based, ya que simplifica las fases de fusión e integración. Esta práctica consiste en la creación de ramas de corta duración, sobre la que un pequeño grupo de desarrolladores trabaja en features que luego integra en una rama principal. Las confirmaciones también son más breves, por lo que el desarrollo de la infraestructura y la disponibilización de recursos de cómputo será más ágil que en un práctica de Gitflow.

![Diagrama de trunkbased](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/trunbkbased.png)

Por otro lado, se propone emplear GitFlow como práctica para el desarrollo de los demás componentes a desarrollar, a saber: el backend y el frontend. Se propone GitFlow pues permite desarrollar un producto que se puede ajustar ciclos de publicación programados, que necesitan varias confirmaciones y que necesitan pasar por varios procesos de validación antes de ser entregados al cliente en producción.

![Diagrama de gitflow](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/gitflow.png)

### 1.3.4. Tecnologías aplicadas

Para implementar el método DevOps en esta primera etapa se eligió:

1. Github para definir los repositorios de código.
2. Github Actions como herramienta para CI/CD.
3. AWS Elastic Container Service como orquestador.
4. Terraform para la infraestructura como código.
5. Sonar Cloud para el análisis de código estático.
6. Newman/Postman para realizar pruebas sobre los microserivicios.
7. React como el servicio Frontend.
8. API Gateway como servicio serverless en AWS.

### 1.3.5. Tablero Kanban

Para organizar el trabajo a realizar durante el obligatorio se empleó ClickUp.com para implementar un tablero Kanban donde se definieron varios estados posibles para las tareas: PENDIENTE, EN PROCESO, BLOQUEADO, EN REVISIÓN y COMPLETADO.

Primera etapa de trabajo:

![Kanban 1](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/evidencia/kanban/1.png)

Mitad y cierre del proyecto:

![Kanban 1](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/evidencia/kanban/2.png)

![Kanban 1](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/evidencia/kanban/3.png)

## 2. Conclusiones

### 2.1. Limitaciones

Si bien la arquitectura en la nube funciona como primer prototipo de implementación y como disparador para la implementación DevOps en la empresa, es necesario señalar algunas limitaciones del modelo de arquitectura que se terminó por definir:

En primer lugar, en la VPC no se definen redes privadas y en la práctica los ALB serían accesibles desde Internet a través de sus IP's públicas. Si bien la funcionalidad a través de la API Gateway es accesible, conceptualmente la implementación no es sólida, pues expone puntos de acceso a recursos por vías diferentes a los de la API Gateway. Idealmente, todos los recusos de la VPC, salvo los estrictamente necesarios, deberían estar asegurados detrás de redes privadas. Esto no solo sería conceptualmente consecuente con las intenciones iniciales (de exponer todo el cluster de microservicios a través de un solo punto de acceso), sino también sería más seguro.

Por otro lado, también se debe destacar que el acceso a los ALB se realiza directamente a través de su dirección pública desde la API Gateway. Esto no es ideal, no solo por lo discutido en el párrafo anterior, sino porque debería realizarse a través de una conexión privada dentro la de la VPC. En términos simples, cuando un microservicio, como Orders, solicita los productos al microservicio Products, debe realizarlo a través de una solicitud que sale de la VPC hacia Internet para volver a entrar a la VPC a través de la API Gateway. Para lograr que esto no sea así, se debería implementar la comunicación de la API Gateway con cada ALB a través de un VPC Link que permita conectar recursos dentro de la red privada sin necesidad de salir a Internet. De nuevo, no solo sería conceptualmente adecuado, sino además más seguro, pues ese tráfico entre microservicios se podría mantener absolutamente privado y aislado dentro de la VPC.

Estas limitaciones se debieron principalmente a limitaciones de tiempo en la implementación y recursos en AWS Academy, que condujeron a definir un mínimo producto viable para la primera etapa de implementación.

### 2.2. Mejoras futuras

En función de las limitaciones discutidas en la sección anterior, se propone una  segunda etapa de revisión de la arquitectura, más correcta y segura para la organización. Véase que en el siguiente diagrama se agregan dos subredes públicas y dos privadas (contrario a las dos públicas que se implementaron), en las que se implementan una NAT Gateway que permita a los contenedores el acceso a Internet (necesario para obtener las imágenes de los repositorios en Docker Hub) y se definen los microservicios allí dentro. Luego, a través de VPC Links se conectan estos microservicios a la API Gateway para ser consumidos desde Internet.

![Kanban 1](https://github.com/RIBAS-DEVOPS-NOV2024/infraestructura/blob/main/assets/implementacion_futura.png)

