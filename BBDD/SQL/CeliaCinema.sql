DROP DATABASE CeliaCinema;
CREATE DATABASE IF NOT EXISTS CeliaCinema;
USE CeliaCinema;

CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    year INTEGER,
    duration INTEGER,
    country VARCHAR(100),
    poster VARCHAR(255)
);

CREATE TABLE people (
    id INT AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(100),
    lastname VARCHAR(100),
    yearOfBirth INT,
    country VARCHAR(100),
    picture VARCHAR(255)
);

CREATE TABLE act (
    idMovie INT,
    idPerson INT,
    FOREIGN KEY (idMovie) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (idPerson) REFERENCES people(id) ON DELETE CASCADE,
    PRIMARY KEY (idMovie, idPerson)
);

CREATE TABLE direct (
    idMovie INT,
    idPerson INT,
    FOREIGN KEY (idMovie) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (idPerson) REFERENCES people(id) ON DELETE CASCADE,
    PRIMARY KEY (idMovie, idPerson)
);

INSERT INTO movies (id, title, year, duration, country, poster) VALUES
(1, 'Inception', 2010, 148, 'USA', 'https://m.media-amazon.com/images/I/91Rc8cAmnAL.jpg'),
(2, 'The Shawshank Redemption', 1994, 142, 'USA', 'https://thesaintaq.files.wordpress.com/2018/11/picture1.png?w=801'),
(3, 'The Godfather', 1972, 175, 'USA', 'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg'),
(4, 'Pulp Fiction', 1994, 154, 'USA', 'https://musicart.xboxlive.com/7/767c6300-0000-0000-0000-000000000002/504/image.jpg?w=1920&h=1080'),
(5, 'The Dark Knight', 2008, 152, 'USA', 'https://m.media-amazon.com/images/S/pv-target-images/e9a43e647b2ca70e75a3c0af046c4dfdcd712380889779cbdc2c57d94ab63902.jpg');


INSERT INTO people (id, firstname, lastname, yearOfBirth, country, picture) VALUES
(1, 'Actor1', 'Apellido1', 1980, 'Estados Unidos', 'https://covalto-production-website.s3.amazonaws.com/Hero_Mobile_Cuenta_Personas_V1_1_8046e424ea.webp'),
(2, 'Actor2', 'Apellido2', 1990, 'Reino Unido', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSU7Zdi_F4g3uzBLLcHNEt64Oh2lJ-3po_rPV4GS2RFQ&s'),
(3, 'Director1', 'Apellido3', 1975, 'España', 'https://mymodernmet.com/wp/wp-content/uploads/2019/09/100k-ai-faces-8.jpg');

INSERT INTO act (idMovie, idPerson) VALUES
(1, 1),
(1, 2);

INSERT INTO direct (idMovie, idPerson) VALUES
(1, 3);
