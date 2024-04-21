CREATE DATABASE IF NOT EXISTS CeliaCinema;
USE CeliaCinema;
-- Crear la tabla Movies
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255),
    year INTEGER,
    duration INTEGER,
    country VARCHAR(100),
    poster VARCHAR(255)
);

-- Insertar registros en la tabla Movies
INSERT INTO movies (id, title, year, duration, country, poster) VALUES
(1, 'Inception', 2010, 148, 'USA', 'https://m.media-amazon.com/images/I/91Rc8cAmnAL.jpg'),
(2, 'The Shawshank Redemption', 1994, 142, 'USA', 'https://thesaintaq.files.wordpress.com/2018/11/picture1.png?w=801'),
(3, 'The Godfather', 1972, 175, 'USA', 'https://m.media-amazon.com/images/M/MV5BM2MyNjYxNmUtYTAwNi00MTYxLWJmNWYtYzZlODY3ZTk3OTFlXkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_.jpg'),
(4, 'Pulp Fiction', 1994, 154, 'USA', 'https://musicart.xboxlive.com/7/767c6300-0000-0000-0000-000000000002/504/image.jpg?w=1920&h=1080'),
(5, 'The Dark Knight', 2008, 152, 'USA', 'https://m.media-amazon.com/images/S/pv-target-images/e9a43e647b2ca70e75a3c0af046c4dfdcd712380889779cbdc2c57d94ab63902.jpg');

