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
(1, 'Inception', 2010, 148, 'USA', 'inception_poster.jpg'),
(2, 'The Shawshank Redemption', 1994, 142, 'USA', 'shawshank_redemption_poster.jpg'),
(3, 'The Godfather', 1972, 175, 'USA', 'godfather_poster.jpg'),
(4, 'Pulp Fiction', 1994, 154, 'USA', 'pulp_fiction_poster.jpg'),
(5, 'The Dark Knight', 2008, 152, 'USA', 'dark_knight_poster.jpg');
