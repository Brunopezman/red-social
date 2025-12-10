# PREGUNTAS DE EXAMEN - BDD

## MODELO 1

**1. Dado el siguiente caso de estudio: En una empresa de servicios de limpieza en alutra se tiene informacion acerca de los tipos de servicios brindados y de los clientes. Tambien se almacenan servicios que tiene contratado cada cliente con la empresa y la frecuencia de ejecucion de cada servicio.**
- Definir tablas y atributos
- Definir la estructura en una base de datos relacional
- Que indices utilizaria. justificar.
- Definir la estructura en una base de datos no relacional. 
- Definir dimensiones y hechos para armar un DataWarehousing

Clientes: razon_social PK, cuit, direccion, telefono, email

TiposServicios: nombre_servicio PK, descripcion, costo

ClientesServicios: razon_social PK FK, nombre_servicio PK FK, frecuencia_ejecucion, fecha, estado

```sql
    CREATE TABLE Clientes (
        razon_social VARCHAR(50) PRIMARY KEY,
        cuit VARCHAR(20) NOT NULL UNIQUE,
        telefono INT,
        email VARCHAR(50)
    )

    CREATE TABLE TiposServicios (
        nombre VARCHAR(50) PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL,
        costo DECIMAL(10,2) NOT NULL
    )

    CREATE TABLE ClientesServicios (
        razon_social_cliente VARCHAR(50) NOT NULL,
        nombre_servicio VARCHAR(50) NOT NULL ,
        frecuencia_ejecucion VARCHAR(20) NOT NULL,
        fecha TIMESTAMP NOT NULL,
        estado VARCHAR(10) NOT NULL CHECK(estado IN('en proceso', 'finalizado'))

        PRIMARY KEY (razon_social_cliente, nombre_servicio),
        FOREIGN KEY (razon_social_cliente) REFERENCES Clientes(razon_social),
        FOREIGN KEY (nombre_servicio) REFERENCES TiposServicios(nombre)
    )
```

Utlizaria los siguientes indices de tipo B+ Tree:
-  Para la tabla Clientes utilizaria un indice para cuit y para razon social dado que es frecuente buscar clientes por dichos identificadores para facturar o consultarn rapidamente.
- Para la tabla TiposServicios utilizaria un indice en nombr para acceder rapidamente a los servicios disponibles en la empresa.
- Para la tabla ClientesServicios utilizaria un indice en razon_social_cliente para acceder rapidamente a todos los servicios contratados por un determinado cliente, y un indice para nombre_servicio dado que se va a necesitar acceder tambien a todos los clientes que contrataron un determinado servicio.

Para estructurar la base NoSQL, creo un unico documento de clientes, y por cada agregado, tenemos un atributo ServiciosContratados, el cual sera un arreglo con los servicios que contrato el cliente junto a sus frecuencias de ejecucion.


```javascript
db.createCollection("Clientes");
```

Vamos a definir como HECHO principal a ServicioContratado cuya medida sera monto_facturado y a las dimensiones como Cliente, TipoServicio, fecha, estado.

```mermaid
    %%{init: {'theme': 'redux'}}%%
    flowchart TB
        A(["estado"]) & D(["fecha"]) & E(["TipoServicio"]) --- B["ServicioContratado"]
        B --- C(["Clientes"]) 

        %% Definición de estilo: círculo con borde punteado
        classDef dottedCircle stroke:#333,stroke-width:2px,stroke-dasharray:4 4,fill:#fff;

        %% Aplicar estilo a los nodos deseados
        class A,D,E,C dottedCircle;
```

**2. Dar un ejemplo de un atributo o un conjunto de atributos que sea PK y FK a la vez.**          

Supongamos la entidad empleado y su especializacion gerente. DNI es la PK de empleado por lo que gerente la va a heredar como PK que su vez sera tambien su FK que referencia a Empleado.

**3. Explicar el concepto de recuperacion de base de datos de forma resumida.**      

La recuperacion de base de datos es el proceso mediante el cual una base de datos vuelve a un estado consistente despues de cualquier tipo de falla. Se basa principalmente en:
- Logs(registros de transacciones): Guardan cada cambio antes de aplicarse (WAL)
- Transacciones: Se aseguran que cada operacion sea atomica.
- Mecanismos UNDO y REDO: Se deshacen transacciones que no se completaron al momento de la falla y se rehacen transacciones que ya estaban commiteadas pero sus cambios no llegaron a escribirse en el disco.
- Checkpoints: Puntos de guardado que facilitan la recuperacion rapida.

**4. Explicar brevemente los conceptos de consistencia y disponibilidad en bases de datos distribuidas.**

La consistencia es la propiedad de que, despues de cualquier operacion, todos los nodos del sistema vean el mismo dato actualizado al mismo tiempo.

La disponibilidad es la garantia de que cada solicitud realizada a un nodo que no ha fallado recibe una respuesta, sin importar el estado de otros nodos.

Como el sistema en la practica debe ser tolearante a fallas, se busca una solucion de compromiso entre consistencia y disponibilidad.