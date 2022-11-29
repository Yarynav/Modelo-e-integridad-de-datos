CREATE DATABASE yaritza_navarrete_01;

\c yaritza_navarrete_01

1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos

CREATE TABLE "peliculas" (
"id" SERIAL,
"nombre" VARCHAR(255),
"anno" INT,
PRIMARY KEY ("id")
);


CREATE TABLE "tags" (
"id" SERIAL,
"tag" VARCHAR(32),
PRIMARY KEY ("id")
);

CREATE TABLE "pelicula_tag" (
"pelicula_id" INT,
"tag_id" INT,
FOREIGN KEY ("pelicula_id")
REFERENCES "peliculas"("id"),
FOREIGN KEY ("tag_id")
REFERENCES "tags"("id")
);



2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados.


INSERT INTO peliculas (nombre, anno) VALUES 
('El señor de los anillos', 2001),
('Star wars IV', 1977),
('Start wars I', 1999),
('El laberinto del fauno', 2006),
('Coraline', 2009);

INSERT INTO tags (tag) VALUES 
('Ciencia ficción'),
('Misterio'),
('Fantasia'),
('Acción'),
('Aventura');


INSERT INTO pelicula_tag(pelicula_id, tag_id) VALUES
(1, 1),
(1, 3),
(1, 5);

INSERT INTO pelicula_tag(pelicula_id, tag_id) VALUES
(2, 1),
(2, 4);


3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0.


SELECT COUNT(pelicula_tag), peliculas.nombre 
FROM peliculas 
LEFT JOIN pelicula_tag ON pelicula_tag.pelicula_id = peliculas.id
GROUP BY peliculas.nombre;

4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos. 

CREATE TABLE Preguntas(
  "id" SERIAL,
  "pregunta" VARCHAR(255),
  "respuesta_correcta" VARCHAR,
  PRIMARY KEY ("id")
);

CREATE TABLE Usuarios(
  "id" SERIAL,
  "nombre" VARCHAR(255),
  "edad" INT,
  PRIMARY KEY ("id")
);

CREATE TABLE Respuestas (
  "id" SERIAL,
  "respuesta" VARCHAR(255),
  "usuario_id" INT,
  "pregunta_id" INT,
  PRIMARY KEY ("id"),
  FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id"),
  FOREIGN KEY ("pregunta_id") REFERENCES "preguntas"("id")
);

5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.


INSERT INTO Usuarios (nombre, edad) VALUES
('Aquiles Baeza', 20),
('Alan Brito',26),
('Elba Lazo',19),
('Marcia Ana', 35),
('Armando Casas', 42);

INSERT INTO preguntas(pregunta, respuesta_correcta) VALUES
('¿a que edad murio marilyn monroe?', '36'),
('¿cuando se extinguieron los dinosaurios?', 'hace 66 millones de años'),
('¿Cual es la primera cancion de the beatles?', 'Love me do'),
('¿cual es el primer disco de los prisioneros?','La voz de los 80'),
('¿cual es el primer cancion de los prisioneros?','Paramar');

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
('36', 1, 1),
('36', 2, 1);

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES
('hace 66 millones de años', 1, 2),
('No me sé esa :c', 3, 2),
('Ahhhh no sé', 4, 2);

6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta).

SELECT 
	usuarios.id, 
	usuarios.nombre, 
	(
		SELECT COUNT(respuestas) FROM respuestas 
		LEFT JOIN preguntas ON respuestas.pregunta_id = preguntas.id
		WHERE respuestas.respuesta = preguntas.respuesta_correcta  AND respuestas.usuario_id = usuarios.id 
	)
FROM usuarios 
GROUP BY usuarios.id, usuarios.nombre;

7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta.

SELECT 
	preguntas.id, 
	preguntas.pregunta, 
		(
		SELECT COUNT(respuestas) FROM respuestas 
		LEFT JOIN usuarios ON respuestas.usuario_id = usuarios.id
		WHERE respuestas.respuesta = preguntas.respuesta_correcta  AND respuestas.pregunta_id = preguntas.id 
	)
FROM preguntas 
GROUP BY preguntas.id, preguntas.pregunta;

8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación.


DELETE FROM usuarios WHERE usuarios.id = 1;



ALTER TABLE respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD CONSTRAINT respuestas_usuario_id_fkey
  FOREIGN KEY (usuario_id)
  REFERENCES usuarios(id)
  ON DELETE CASCADE;

  9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos.

ALTER TABLE usuarios
ADD CONSTRAINT check_age CHECK(edad >= 18);

INSERT INTO usuarios (nombre, edad) VALUES ('Aquiles Baeza Junior', 15);


10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
único. 

ALTER TABLE usuarios
ADD COLUMN email VARCHAR(255);

ALTER TABLE usuarios
ADD CONSTRAINT email_unique UNIQUE (email);

INSERT INTO usuarios (nombre, edad, email) VALUES ('Aquiles Baeza Junior', 18, 'abaeza@mail.com');
INSERT INTO usuarios (nombre, edad, email) VALUES ('Aquiles Baeza Junior 2', 20, 'abaeza@mail.com');