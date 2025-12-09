# PREGUNTAS DE EXAMEN - BDD

## MODELO 1

### Costos y Optimización de Consultas
Explique el proceso que realiza un Optimizador de Consultas en un SGBD para pasar de una consulta SQL al Plan de Ejecución más eficiente.

Mencione qué elementos clave utiliza el optimizador para estimar el costo de un plan (e.g., estadísticas, catálogo) y por qué la estimación de costos es fundamental para garantizar un tiempo de respuesta óptimo.

### Recuperación y Log de BD
Describa en detalle la Regla WAL (Write-Ahead Logging). Explique su propósito en el contexto del gestor de recuperación de la base de datos y cómo garantiza la durabilidad de las transacciones frente a fallas del sistema o del medio de almacenamiento.

### Data Warehousing (Tablas de Hechos y Dimensiones)
Describa la estructura de un modelo de datos en estrella (Star Schema), propio de un Data Warehouse (DW).

Defina las Tablas de Hechos (Fact Tables) y las Tablas de Dimensiones (Dimension Tables), indicando las diferencias en el tipo de datos que almacena cada una (e.g., claves, medidas, atributos descriptivos).

Mencione y ejemplifique tres (3) operaciones típicas de OLAP (Online Analytical Processing).

### Transacciones y Propiedades ACID
Describa y ejemplifique el problema de Lectura Sucia (Dirty Read).

Explique qué propiedad ACID se ve directamente comprometida por esta anomalía.

Describa brevemente cómo el Protocolo de Lock de Dos Fases (2PL) evita este tipo de anomalías, especificando en qué fase se obtienen los locks de lectura/escritura.

### Pregunta 5: Tipos y Estructuras de Índices
Describa las diferencias fundamentales entre un Índice Clustered (Agrupado) y un Índice Unclustered (No Agrupado o Secundario).

Explique cómo afecta cada tipo de índice a la organización física de los datos en disco.

Justifique por qué solo puede haber un índice clustered por tabla.

Mencione brevemente la estructura más utilizada para implementar estos índices (típicamente, el árbol B+).
