<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@include file="header.jsp" %>
<% 
    // Vamos a ver si en la petición se nos ha indicado acción y controlador.
    // Si no, usaremos un controlador y una acción por defecto.
    String action = request.getParameter("action");    

    if ((action == null) || action.equals("")) {
        action = "showAllMovies";       // Acción por defecto
    }

    /**************** MOVIES *******************/

    // ----showAllMovies----
    if (action.equals("showAllMovies")) {
        out.println("<form action='' method='post'>");
        out.println("<button id='add' type='submit' name='action' value='formNewMovie'>Añadir película</button>");
        out.println("</form>");
        out.println("<style>");
        out.println("#add {");
        out.println("    margin: 20px;");
        out.println("    padding: 10px 20px;");
        out.println("    color: #fff;");
        out.println("    text-decoration: none;");
        out.println("    border-radius: 5px;");
        out.println("    background-color: #555;");
        out.println("}");
        out.println("#add:hover {");
        out.println("    background-color: #777;");
        out.println("}");
        out.println("</style>");
        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT
            Statement st = con.createStatement();
            String sql = "SELECT * FROM movies";
            ResultSet rs = st.executeQuery(sql);

            // Mostramos los resultados como una tabla HTML
            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th><th colspan='3'>Acciones</th></tr></thead><tbody>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("title") + "</td>");
                out.print("<td>" + rs.getInt("year") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td>" + rs.getInt("duration") + " min</td>");
                out.print("<td><img src='" + rs.getString("poster") + "' height='150px'></td>");
                out.print("<form action='' method='post'>");
                out.print("<input type='hidden' name='movieId' value='" + rs.getInt("id") + "'>");
                out.print("<td><button type='submit' name='action' value='showMovie'>Detalles</button></td>");
                out.print("<td><button type='submit' name='action' value='formEditMovie'>Modificar</button></td>");
                out.print("<td><button type='submit' name='action' value='deleteMovie'>Borrar</button></td>");
                out.print("</form>");
            }
            out.println("</tbody></table></div>");
            
            // Lo cerramos todo
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
    }

    // ----showMovie----
    if (action.equals("showMovie")) {
        String movieId = request.getParameter("movieId");

        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT para obtener los detalles de la película específica
            String sql = "SELECT * FROM movies WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery();

            // Mostramos los detalles de la película como una tabla HTML
            if (rs.next()) {
                out.println("<div class='container'><table align='center'>");
                out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th></tr></thead><tbody>");
                out.print("<tr><td>" + rs.getString("id") + "</td>");
                out.print("<td>" + rs.getString("title") + "</td>");
                out.print("<td>" + rs.getString("year") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td>" + rs.getString("duration") + " min</td>");
                out.print("<td><img src='" + rs.getString("poster") + "' height='400px'></td>");
                out.println("</tbody></table></div>");
            }
            
            // Cerramos los recursos
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
    }


    // ----formNewMovie----
    if (action.equals("formNewMovie")) {
        out.println("<div class='container'>");
        out.println("<h2>Nueva Película</h2>");
        out.println("<form action='' method='post' onsubmit='return validateForm()'>");
        out.println("<label for='title'>Título:</label><br>");
        out.println("<input type='text' id='title' name='title'><br>");
        out.println("<label for='year'>Año:</label><br>");
        out.println("<input type='text' id='year' name='year'><br>");
        out.println("<label for='country'>País:</label><br>");
        out.println("<input type='text' id='country' name='country'><br>");
        out.println("<label for='duration'>Duración (minutos):</label><br>");
        out.println("<input type='text' id='duration' name='duration'><br>");
        out.println("<label for='poster'>URL del cartel:</label><br>");
        out.println("<input type='text' id='poster' name='poster'><br><br>");
        out.print("<button type='submit' name='action' value='newMovie'>Guardar</button>");
        out.println("</form>");
        out.println("</div>");
    }

        // JavaScript para validar el formulario
        out.println("<script>");
        out.println("function validateForm() {");
        out.println("var title = document.getElementById('title').value;");
        out.println("var year = document.getElementById('year').value;");
        out.println("var country = document.getElementById('country').value;");
        out.println("var duration = document.getElementById('duration').value;");
        out.println("if (title === '' || year === '' || country === '' || duration === '') {");
        out.println("alert('Todos los campos son obligatorios');");
        out.println("return false;"); // Evitar que se envíe el formulario si hay campos vacíos
        out.println("}");
        out.println("if (isNaN(year) || isNaN(duration)) {");
        out.println("alert('El año y la duración deben ser números enteros');");
        out.println("return false;"); // Evitar que se envíe el formulario si el año o la duración no son números
        out.println("}");
        out.println("return true;"); // Enviar el formulario si todos los campos son válidos
        out.println("}");
        out.println("</script>");

    // ----newMovie----
    if (action.equals("newMovie")) {
        String title = request.getParameter("title");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String durationStr = request.getParameter("duration");
        String poster = request.getParameter("poster");

        try {
            int year = Integer.parseInt(yearStr);
            int duration = Integer.parseInt(durationStr);

            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "INSERT INTO movies (title, year, duration, country, poster) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setInt(2, year);
            ps.setInt(3, duration);
            ps.setString(4, country);
            ps.setString(5, poster);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("#");
            }

            // Cerramos los recursos
            ps.close();
            con.close();
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    } 

    // ----formEditMovie----
    if (action.equals("formEditMovie")) {
            String movieId = request.getParameter("movieId");
            try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT para obtener los detalles de la película específica
            String sql = "SELECT * FROM movies WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery();

            // Mostramos los detalles de la película como una tabla HTML
            if (rs.next()) {
                String title = rs.getString("title");
                String year = rs.getString("year");
                String country = rs.getString("country");
                String duration = rs.getString("duration");
                String poster = rs.getString("poster");

                out.println("<div class='container'><table align='center'>");
                out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th></tr></thead><tbody>");
                out.print("<tr><td>" + rs.getString("id") + "</td>");
                out.print("<td>" + title + "</td>");
                out.print("<td>" + year + "</td>");
                out.print("<td>" + country + "</td>");
                out.print("<td>" + duration + " min</td>");
                out.print("<td><img src='" + poster + "' height='400px'></td>");
                out.println("</tbody></table>");

                out.println("<h2>Editar Película</h2>");
                out.println("<form action='' method='post' onsubmit='return validateForm()'>");
                out.println("<label for='title'>Título:</label><br>");
                out.print("<input type='hidden' name='movieId' value='" + movieId + "'>");
                out.println("<input type='text' id='title' name='title' value = '" + title + "''><br>");
                out.println("<label for='year'>Año:</label><br>");
                out.println("<input type='text' id='year' name='year' value = '" + year + "'><br>");
                out.println("<label for='country'>País:</label><br>");
                out.println("<input type='text' id='country' name='country' value = '" + country + "'><br>");
                out.println("<label for='duration'>Duración (minutos):</label><br>");
                out.println("<input type='text' id='duration' name='duration' value = '" + duration + "'><br>");
                out.println("<label for='poster'>URL del cartel:</label><br>");
                out.println("<input type='text' id='poster' name='poster' value = '" + poster + "''><br><br>");
                out.print("<button type='submit' name='action' value='editMovie'>Guardar</button>");
                out.println("</form>");
                out.println("</div>");
            }
            
            // Cerramos los recursos
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
    }

    // ----editMovie----
    if (action.equals("editMovie")) {
        String title = request.getParameter("title");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String durationStr = request.getParameter("duration");
        String poster = request.getParameter("poster");
        String movieId = request.getParameter("movieId");

        try {
            int year = Integer.parseInt(yearStr);
            int duration = Integer.parseInt(durationStr);

            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "UPDATE movies SET title = ?, year = ?, duration = ?, country = ?, poster = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setInt(2, year);
            ps.setInt(3, duration);
            ps.setString(4, country);
            ps.setString(5, poster);
            ps.setInt(6, Integer.parseInt(movieId));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("#");
            }

            // Cerramos los recursos
            ps.close();
            con.close();
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    // ----deleteMovie----
    if (action.equals("deleteMovie")) {
        String movieId = request.getParameter("movieId");
        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "DELETE FROM movies WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(movieId));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("#");
            }

            // Cerramos los recursos
            ps.close();
            con.close();
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }


    /**************** PEOPLE *******************/

    // ----showAllPeople----
    if (action.equals("showAllPeople")) {
            out.println("<form action='' method='post'>");
            out.println("<button id='add' type='submit' name='action' value=''>Añadir persona</button>");
            out.println("</form>");
            out.println("<style>");
            out.println("#add {");
            out.println("    margin: 20px;");
            out.println("    padding: 10px 20px;");
            out.println("    color: #fff;");
            out.println("    text-decoration: none;");
            out.println("    border-radius: 5px;");
            out.println("    background-color: #555;");
            out.println("}");
            out.println("#add:hover {");
            out.println("    background-color: #777;");
            out.println("}");
            out.println("</style>");
            try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT
            Statement st = con.createStatement();
            String sql = "SELECT * FROM people";
            ResultSet rs = st.executeQuery(sql);

            // Mostramos los resultados como una tabla HTML
            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th colspan='3'>Acciones</th></tr></thead><tbody>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + " </td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='150px'></td>");
                out.print("<form action='' method='post'>");
                out.print("<input type='hidden' name='personId' value='" + rs.getInt("id") + "'>");
                out.print("<td><button type='submit' name='action' value='showPerson'>Detalles</button></td>");
                out.print("<td><button type='submit' name='action' value=''>Modificar</button></td>");
                out.print("<td><button type='submit' name='action' value=''>Borrar</button></td>");
                out.print("</form>");
            }
            out.println("</tbody></table></div>");
            
            // Lo cerramos todo
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
    }

    // ----showPerson----
    if (action.equals("showPerson")) {
        String personId = request.getParameter("personId");

        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT para obtener los detalles de la película específica
            String sql = "SELECT * FROM people WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, personId);
            ResultSet rs = ps.executeQuery();

            // Mostramos los detalles de la película como una tabla HTML
            if (rs.next()) {
                out.println("<div class='container'><table align='center'>");
                out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th></thead><tbody>");
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='400px'></td>");
                out.println("</tbody></table></div>");
            }
            
            // Cerramos los recursos
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
    }

    // ----formNewPerson----
    if (action.equals("formNewPerson")) {
        // Aquí irá el código para mostrar el formulario de nueva persona
        out.println("Opción en desarrollo: mostrará un formulario para crear una nueva persona.");
    }

    // ----newPerson----
    if (action.equals("newPerson")) {
        // Aquí irá el código para crear una nueva persona
        out.println("Opción en desarrollo: creará una nueva persona en la base de datos.");
    }

    // Etc.

%>
<%@include file="footer.jsp" %>