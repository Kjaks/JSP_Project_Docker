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
                out.print("<td><button type='submit' name='Modificar' value='Modificar'>Modificar</button></td>");
                out.print("<td><button type='submit' name='Borrar' value='Borrar'>Borrar</button></td>");
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
            } else {
                out.println("La película no se encontró en la base de datos.");
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
        out.println("<form action='' method='post'>");
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
        out.println("<input type='submit' value='Guardar'><br>");
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

        // Validar que los campos no estén vacíos y que year y duration sean ints
        if (title != null && !title.isEmpty() && yearStr != null && !yearStr.isEmpty()
                && country != null && !country.isEmpty() && durationStr != null && !durationStr.isEmpty()) {
            try {
                int year = Integer.parseInt(yearStr);
                int duration = Integer.parseInt(durationStr);

                // Conectamos con la BD
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

                // Ejecutamos un INSERT para agregar la nueva película
                String sql = "INSERT INTO movies (title, year, country, duration, poster) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setInt(2, year);
                ps.setString(3, country);
                ps.setInt(4, duration);
                ps.setString(5, poster);

                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    // Si se inserta correctamente, redirigimos a la página de éxito
                    response.sendRedirect("index.jsp");
                } else {
                    // Mostramos una alerta en caso de error al agregar la película
                    out.println("<script>alert('Error al agregar la película');</script>");
                }

                // Cerramos los recursos
                ps.close();
                con.close();
            } catch (NumberFormatException e) {
                // Mostramos una alerta si el año o la duración no son números enteros
                out.println("<script>alert('El año y la duración deben ser números enteros');</script>");
            } catch (Exception e) {
                // Mostramos una alerta en caso de error de base de datos
                out.println("<script>alert('Error al acceder a la BD');</script>");
            }
        } else {
            // Mostramos una alerta si hay campos vacíos
            out.println("<script>alert('Todos los campos son obligatorios');</script>");
        }
    }


    // ----formEditMovie----
    if (action.equals("formEditMovie")) {
        // Aquí irá el código para mostrar el formulario de edición de película
        out.println("Opción en desarrollo: mostrará un formulario para editar una película.");
    }

    // ----editMovie----
    if (action.equals("editMovie")) {
        // Aquí irá el código para editar una película
        out.println("Opción en desarrollo: editará una película en la base de datos.");
    }

    // ----deleteMovie----
    if (action.equals("deleteMovie")) {
        // Aquí irá el código para borrar una película
        out.println("Opción en desarrollo: borrará una película de la base de datos.");
    }


    /**************** PEOPLE *******************/

    // ----showAllPeople----
    if (action.equals("showAllPeople")) {
        // Aquí irá el código para mostrar todas las personas
        out.println("Opción en desarrollo: mostrará todas las personas de la base de datos.");
    }

    // ----showPerson----
    if (action.equals("showPerson")) {
        // Aquí irá el código para mostrar una persona
        out.println("Opción en desarrollo: mostrará los datos de una persona en concreto.");
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