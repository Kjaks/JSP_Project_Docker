<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.Enumeration" %>
<%@include file="header.jsp" %>
<% 
    // Vamos a ver si en la petición se nos ha indicado acción y controlador.
    // Si no, usaremos un controlador y una acción por defecto.
    String action = request.getParameter("action");    

    if ((action == null) || action.equals("")) {
        action = "showAllMovies";       // Acción por defecto
    }

    /**************** MOVIES *******************/

    // JavaScript para validar el formulario
    out.println("<script>");
    out.println("function validateMovieForm() {");
    out.println("var title = document.getElementById('title').value;");
    out.println("var year = document.getElementById('year').value;");
    out.println("var country = document.getElementById('country').value;");
    out.println("var duration = document.getElementById('duration').value;");
    out.println("var poster = document.getElementById('poster').value;");
    out.println("if (title === '' || year === '' || country === '' || duration === '' || poster === '') {");
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

    out.println("<script>function reloadPage() {window.location.reload();}</script>");
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

        out.println("<form action='' method='post' id='actForm'>");
        out.println("<button id='add' type='submit' name='action' value='formNewParticipants''>Añadir participantes</button>");
        out.print("<input type='hidden' id='movieId' name='movieId' value='" + movieId + "'>");
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

        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT
            Statement st = con.createStatement();
            String sql = "SELECT * FROM people INNER JOIN act ON people.id = act.idPerson WHERE act.idMovie = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery(); // Utiliza ps.executeQuery() en lugar de st.executeQuery(sql)


            // Mostramos los resultados como una tabla HTML
            out.println("<h2>Actores</h2><style>h2 {text-align: center;}</style>");
            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th></tr></thead><tbody>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + " </td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='150px'></td>");
                out.print("<form action='' method='post'>");
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
        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un SELECT
            Statement st = con.createStatement();
            String sql = "SELECT * FROM people INNER JOIN direct ON people.id = direct.idPerson WHERE direct.idMovie = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery(); // Utiliza ps.executeQuery() en lugar de st.executeQuery(sql)


            // Mostramos los resultados como una tabla HTML
            out.println("<h2>Director/es</h2><style>        h2 {text-align: center;}</style>");
            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th></tr></thead><tbody>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + " </td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='150px'></td>");
                out.print("<input type='hidden' name='movieId' value='" + movieId + "'>");
                out.print("<form action='' method='post'>");
                out.print("</form>");
            }
            out.println("</tbody></table></div>");
            
            // Lo cerramos todo
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            out.println("<scriptError al acceder a la BD: " + e.toString());
        }
    }

        out.println("<script>");
        out.println("function addParticipant(movieId, personId) {");
        out.println("    var xhr = new XMLHttpRequest();");
        out.println("    xhr.open('POST', 'index.jsp', true);");
        out.println("    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');");
        out.println("    xhr.onreadystatechange = function() {");
        out.println("        if (xhr.readyState === 4) {");
        out.println("            if (xhr.status === 200) {");
        out.println("                if (xhr.responseText.trim() === 'success') {");
        out.println("                    alert('Participante agregado exitosamente');");
        out.println("                } else {");
        out.println("                    // Error al agregar el participante");
        out.println("                    location.reload();");
        out.println("                }");
        out.println("            } else {");
        out.println("                // Error en la solicitud AJAX");
        out.println("                alert('Error en la solicitud AJAX: ' + xhr.statusText);");
        out.println("            }");
        out.println("        }");
        out.println("    };");
        out.println("    xhr.send('action=addAct&movieId=' + encodeURIComponent(movieId) + '&personId=' + encodeURIComponent(personId));");
        out.println("}");
        out.println("</script>");

        out.println("<script>");
        out.println("function deleteParticipant(movieId, personId) {");
        out.println("    var xhr = new XMLHttpRequest();");
        out.println("    xhr.open('POST', 'index.jsp', true);");
        out.println("    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');");
        out.println("    xhr.onreadystatechange = function() {");
        out.println("        if (xhr.readyState === 4) {");
        out.println("            if (xhr.status === 200) {");
        out.println("                if (xhr.responseText.trim() === 'success') {");
        out.println("                    alert('Participante agregado exitosamente');");
        out.println("                } else {");
        out.println("                    // Error al agregar el participante");
        out.println("                    location.reload();");
        out.println("                }");
        out.println("            } else {");
        out.println("                // Error en la solicitud AJAX");
        out.println("                alert('Error en la solicitud AJAX: ' + xhr.statusText);");
        out.println("            }");
        out.println("        }");
        out.println("    };");
        out.println("    xhr.send('action=deleteAct&movieId=' + encodeURIComponent(movieId) + '&personId=' + encodeURIComponent(personId));");
        out.println("}");
        out.println("</script>");

    if (action.equals("formNewParticipants")){
        String movieId = request.getParameter("movieId");
        out.println("<h2>Actuan</h2><style>h2 {text-align: center;}</style>");
        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Preparar la consulta SQL con un PreparedStatement
            String sql = "SELECT people.* FROM people LEFT JOIN act ON people.id = act.idPerson AND act.idMovie = ? WHERE act.idPerson IS NULL";
            PreparedStatement ps = con.prepareStatement(sql);

            // Establecer el valor del parámetro movieId en la consulta preparada
            ps.setString(1, movieId);

            // Ejecutar la consulta
            ResultSet rs = ps.executeQuery();

            // Mostramos los resultados como una tabla HTML
            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th>Accion</th></tr></thead><tbody>");
            while (rs.next()) {
                int idPerson = rs.getInt("id");
                out.print("<tr><td>" + idPerson + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + " </td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='150px'></td>");
                out.print("<td><button onclick='addParticipant(\"" + movieId + "\", \"" + idPerson + "\")'>Añadir</button></td>");
                out.print("</tr>");
            }
            
            out.println("</tbody></table>");

            out.println("</div>");

            rs.close();
            ps.close();
            con.close();

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con2 = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Preparar la consulta SQL con un PreparedStatement
            String sql2 = "SELECT people.* FROM people INNER JOIN act ON people.id = act.idPerson AND act.idMovie = ?";
            PreparedStatement ps2 = con2.prepareStatement(sql2);

            // Establecer el valor del parámetro movieId en la consulta preparada
            ps2.setString(1, movieId);

            // Ejecutar la consulta
            ResultSet rs2 = ps2.executeQuery();

            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th>Accion</th></tr></thead><tbody>");
            while (rs2.next()) {
                int idPerson = rs2.getInt("id");
                out.print("<tr><td>" + rs2.getInt("id") + "</td>");
                out.print("<td>" + rs2.getString("firstname") + "</td>");
                out.print("<td>" + rs2.getString("lastname") + "</td>");
                out.print("<td>" + rs2.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs2.getString("country") + " </td>");
                out.print("<td><img src='" + rs2.getString("picture") + "' height='150px'></td>");
                out.print("<td><button onclick='deleteParticipant(\"" + movieId + "\", \"" + idPerson + "\")'>Eliminar</button></td>");
                out.print("</tr>");

            }
            
            out.println("</tbody></table>");

            out.println("</div>");

            rs2.close();
            ps2.close();
            con2.close();

            out.println("<h2>Dirigen</h2>");

        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
    }

    if (action.equals("addAct")){
        String movieId = request.getParameter("movieId");
        String personId = request.getParameter("personId");

        try {

            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "INSERT INTO act (idMovie, idPerson) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ps.setString(2, personId);

            int rowsAffected = ps.executeUpdate();

            // Cerramos los recursos
            ps.close();
            con.close();
            response.getWriter().write("success");
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    if (action.equals("deleteAct")){
        String movieId = request.getParameter("movieId");
        String personId = request.getParameter("personId");

        try {

            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "INSERT INTO act (idMovie, idPerson) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ps.setString(2, personId);

            int rowsAffected = ps.executeUpdate();

            // Cerramos los recursos
            ps.close();
            con.close();
            response.getWriter().write("success");
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }
    

    // ----formNewMovie----
    if (action.equals("formNewMovie")) {
        out.println("<div class='container'>");
        out.println("<h2>Nueva Película</h2>");
        out.println("<form action='' method='post' onsubmit='return validateMovieForm()'>");
        out.println("<label for='title'>Título:</label><br>");
        out.println("<input type='text' id='title' name='title'><br>");
        out.println("<label for='year'>Año:</label><br>");
        out.println("<input type='number' id='year' name='year'><br>");
        out.println("<label for='country'>País:</label><br>");
        out.println("<input type='text' id='country' name='country'><br>");
        out.println("<label for='duration'>Duración (minutos):</label><br>");
        out.println("<input type='number' id='duration' name='duration'><br>");
        out.println("<label for='poster'>URL del cartel:</label><br>");
        out.println("<input type='text' id='poster' name='poster'><br><br>");
        out.print("<button type='submit' name='action' value='newMovie'>Guardar</button>");
        out.println("</form>");
        out.println("</div>");
    }

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
                out.println("<form action='' method='post' onsubmit='return validateMovieForm()'>");
                out.println("<label for='title'>Título:</label><br>");
                out.print("<input type='hidden' name='movieId' value='" + movieId + "'>");
                out.println("<input type='text' id='title' name='title' value = '" + title + "''><br>");
                out.println("<label for='year'>Año:</label><br>");
                out.println("<input type='number' id='year' name='year' value = '" + year + "'><br>");
                out.println("<label for='country'>País:</label><br>");
                out.println("<input type='text' id='country' name='country' value = '" + country + "'><br>");
                out.println("<label for='duration'>Duración (minutos):</label><br>");
                out.println("<input type='number' id='duration' name='duration' value = '" + duration + "'><br>");
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
        // JavaScript para validar el formulario
        out.println("<script>");
        out.println("function validatePersonForm() {");
        out.println("var name = document.getElementById('name').value;");
        out.println("var surname = document.getElementById('surname').value;");
        out.println("var year = document.getElementById('year').value;");
        out.println("var country = document.getElementById('country').value;");
        out.println("var image = document.getElementById('image').value;");
        out.println("if (name === '' || country === '' || image === '' || surname === '' || year === '') {");
        out.println("alert('Todos los campos son obligatorios');");
        out.println("return false;"); // Evitar que se envíe el formulario si hay campos vacíos
        out.println("}");
        out.println("if (isNaN(year)) {");
        out.println("alert('El año debe ser un número entero');");
        out.println("return false;"); // Evitar que se envíe el formulario si el año no es un número
        out.println("}");
        out.println("return true;"); // Enviar el formulario si todos los campos son válidos
        out.println("}");
        out.println("</script>");

    // ----showAllPeople----
    if (action.equals("showAllPeople")) {
            out.println("<form action='' method='post'>");
            out.println("<button id='add' type='submit' name='action' value='formNewPerson'>Añadir persona</button>");
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
                out.print("<td><button type='submit' name='action' value='formEditPerson'>Modificar</button></td>");
                out.print("<td><button type='submit' name='action' value='deletePerson'>Borrar</button></td>");
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
                out.print("<td><img src='" + rs.getString("picture") + "' height='150px'></td>");
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

    if (action.equals("formNewPerson")) {
        out.println("<div class='container'>");
        out.println("<h2>Nueva Película</h2>");
        out.println("<form action='' method='post' onsubmit='return validatePersonForm()'>");
        out.println("<label for='name'>Primer nombre:</label><br>");
        out.println("<input type='text' id='name' name='name'><br>");
        out.println("<label for='surname'>Apellidos</label><br>");
        out.println("<input type='text' id='surname' name='surname'><br>");
        out.println("<label for='year'>Año de nacimiento</label><br>");
        out.println("<input type='number' id='year' name='year'><br>");
        out.println("<label for='country'>País</label><br>");
        out.println("<input type='text' id='country' name='country'><br>");
        out.println("<label for='image'>Imagen</label><br>");
        out.println("<input type='text' id='image' name='image'><br><br>");
        out.print("<button type='submit' name='action' value='newPerson'>Guardar</button>");
        out.println("</form>");
        out.println("</div>");
    }


    // ----newPerson----
    if (action.equals("newPerson")) {
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String image = request.getParameter("image");

        try {
            int year = Integer.parseInt(yearStr);

            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "INSERT INTO people (firstname, lastname, yearOfBirth, country, picture) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, surname);
            ps.setInt(3, year);
            ps.setString(4, country);
            ps.setString(5, image);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
            response.sendRedirect("index.jsp?action=showAllPeople");
            }

            // Cerramos los recursos
            ps.close();
            con.close();
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    if (action.equals("formEditPerson")) {
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
                String name = rs.getString("firstname");
                String surname = rs.getString("lastname");
                String year = rs.getString("yearOfBirth");
                String country = rs.getString("country");
                String image = rs.getString("picture");

                out.println("<div class='container'><table align='center'>");
                out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th></thead><tbody>");
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='400px'></td>");
                out.println("</tbody></table>");

                out.println("<h2>Editar Persona</h2>");
                out.println("<form action='' method='post' onsubmit='return validatePersonForm()'>");
                out.println("<label for='title'>Nombre:</label><br>");
                out.print("<input type='hidden' name='personId' value='" + personId + "'>");
                out.println("<input type='text' id='name' name='name' value = '" + name + "''><br>");
                out.println("<label for='surname'>Apellidos:</label><br>");
                out.println("<input type='text' id='surname' name='surname' value = '" + surname + "'><br>");
                out.println("<label for='year'>Año de nacimiento:</label><br>");
                out.println("<input type='number' id='year' name='year' value = '" + year + "'><br>");
                out.println("<label for='country'>Pais:</label><br>");
                out.println("<input type='text' id='country' name='country' value = '" + country + "'><br>");
                out.println("<label for='image'>URL de la imagen:</label><br>");
                out.println("<input type='text' id='image' name='image' value = '" + image + "''><br><br>");
                out.print("<button type='submit' name='action' value='editPerson'>Guardar</button>");
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

    if (action.equals("editPerson")) {
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String image = request.getParameter("image");
        String personId = request.getParameter("personId");

        try {
            int year = Integer.parseInt(yearStr);

            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "UPDATE people SET firstname = ?, lastname = ?, yearOfBirth = ?, country = ?, picture = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, surname);
            ps.setInt(3, year);
            ps.setString(4, country);
            ps.setString(5, image);
            ps.setInt(6, Integer.parseInt(personId));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
            response.sendRedirect("index.jsp?action=showAllPeople");
            }

            // Cerramos los recursos
            ps.close();
            con.close();
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    if (action.equals("deletePerson")) {
        String personId = request.getParameter("personId");
        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            // Ejecutamos un INSERT para agregar la nueva película
            String sql = "DELETE FROM people WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(personId));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp?action=showAllPeople");
            }

            // Cerramos los recursos
            ps.close();
            con.close();
        } catch (Exception e) {
            // Mostramos una alerta en caso de error de base de datos
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

%>
<%@include file="footer.jsp" %>