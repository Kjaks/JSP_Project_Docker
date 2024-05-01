<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@include file="header.jsp" %>
<% 
/**
 * This JSP file serves as the main controller for managing movies.
 * It handles various actions related to movies such as displaying all movies,
 * adding new movies, editing existing ones, and deleting movies.
 */

    /**
     * Let's check if an action and controller have been provided in the request.
     * If not, we'll use a default controller and action.
    */
    String action = request.getParameter("action");    

    if ((action == null) || action.equals("")) {
        action = "showAllMovies";
    }

    /**************** MOVIES *******************/

    /**
     * JavaScript form validation
    */
    out.println("<script>");
    out.println("function validateMovieForm() {");
    out.println("var title = document.getElementById('title').value;");
    out.println("var year = document.getElementById('year').value;");
    out.println("var country = document.getElementById('country').value;");
    out.println("var duration = document.getElementById('duration').value;");
    out.println("var poster = document.getElementById('poster').value;");
    out.println("if (title === '' || year === '' || country === '' || duration === '' || poster === '') {");
    out.println("alert('Todos los campos son obligatorios');");
    out.println("return false;"); 
    out.println("}");
    out.println("if (isNaN(year) || isNaN(duration)) {");
    out.println("alert('El año y la duración deben ser números enteros');");
    out.println("return false;"); 
    out.println("}");
    out.println("return true;");
    out.println("}");
    out.println("</script>");

    /**
     * This functions reload the page after an action is performed
    */
    out.println("<script>function reloadPage() {window.location.reload();}</script>");

    /**
     * This method generates HTML content for displaying all movies and providing options for movie management.
     * If the action is "showAllMovies", it displays a form for adding a new movie, a search form,
     * and a table listing all movies with options to view details, edit, and delete each movie.
     * 
     * @param action The action parameter from the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
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
        out.println("<form action='' method='post'>");
        out.println("<label for=''>Busqueda de peliculas:</label><br>");
        out.println("<input type='text' id='search' name='search'><br>");
        out.println("<button type='submit' name='action' value='searchMovie'>Buscar</button>");
        out.println("</form>");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            Statement st = con.createStatement();
            String sql = "SELECT * FROM movies";
            ResultSet rs = st.executeQuery(sql);

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
            
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * This method generates HTML content for displaying search results based on the movie title.
     * If the action is "searchMovie", it retrieves the search query from the request parameters,
     * queries the database for movies matching the search query, and displays the results in a table.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @return The PrintWriter object for writing HTML content to the response.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
    if (action.equals("searchMovie")) {
        String search = request.getParameter("search");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            Statement st = con.createStatement();
            String sql = "SELECT * FROM movies WHERE title LIKE '%" + search + "%'";
            ResultSet rs = st.executeQuery(sql);

            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th></tr></thead><tbody>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getInt("id") + "</td>");
                out.print("<td>" + rs.getString("title") + "</td>");
                out.print("<td>" + rs.getInt("year") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td>" + rs.getInt("duration") + " min</td>");
                out.print("<td><img src='" + rs.getString("poster") + "' height='400px'></td>");
            }
            out.println("</tbody></table></div>");
            
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * This method generates HTML content for displaying details of a specific movie,
     * including its title, year, country, duration, poster, actors, and directors.
     * If the action is "showMovie", it retrieves the movie ID from the request parameters,
     * queries the database to fetch movie details and associated actors and directors,
     * and displays the information in separate tables. Also provides options to add/remove actors and directors.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @return The PrintWriter object for writing HTML content to the response.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
    */
    if (action.equals("showMovie")) {
        String movieId = request.getParameter("movieId");

        out.println("<form action='' method='post' id='actForm'>");
        out.println("<button id='add' type='submit' name='action' value='formNewAct''>Añadir actores</button>");
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
        
        out.println("<form action='' method='post' id='actForm'>");
        out.println("<button id='add' type='submit' name='action' value='formNewDirect''>Añadir directores</button>");
        out.print("<input type='hidden' id='movieId' name='movieId' value='" + movieId + "'>");
        out.println("</form>");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT * FROM movies WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery();

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
            
            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            Statement st = con.createStatement();
            String sql = "SELECT * FROM people INNER JOIN act ON people.id = act.idPerson WHERE act.idMovie = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery();

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
            
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            Statement st = con.createStatement();
            String sql = "SELECT * FROM people INNER JOIN direct ON people.id = direct.idPerson WHERE direct.idMovie = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery(); 

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
            
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * This JavaScript block contains functions for adding and deleting participants (actors) to/from a movie.
     */
    out.println("<script>");
    out.println("function addParticipant(movieId, personId) {");
    out.println("    var xhr = new XMLHttpRequest();");
    out.println("    xhr.open('POST', 'index.jsp', true);");
    out.println("    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');");
    out.println("    xhr.onreadystatechange = function() {");
    out.println("        if (xhr.readyState === 4) {");
    out.println("            if (xhr.status === 200) {");
    out.println("                    location.reload();");
    out.println("                }");
    out.println("            }}");
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
    out.println("                    location.reload();");
    out.println("                }");
    out.println("            }}");
    out.println("    xhr.send('action=deleteAct&movieId=' + encodeURIComponent(movieId) + '&personId=' + encodeURIComponent(personId));");
    out.println("}");
    out.println("</script>");

    /**
     * This method generates HTML content for displaying a form to add new actors to a movie.
     * If the action is "formNewAct", it retrieves the movie ID from the request parameters,
     * queries the database to fetch existing actors who are not associated with the movie yet,
     * and displays them with an option to add them to the movie.
     * It also lists the actors already associated with the movie and provides an option to delete them.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @return The PrintWriter object for writing HTML content to the response.
     * @throws IOException If an I/O exception occurs while writing the response.
     */
    if (action.equals("formNewAct")){
        String movieId = request.getParameter("movieId");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT people.* FROM people LEFT JOIN act ON people.id = act.idPerson AND act.idMovie = ? WHERE act.idPerson IS NULL";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, movieId);

            ResultSet rs = ps.executeQuery();

            out.println("<div class='container'><table align='left'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th>Accion</th></tr></thead><tbody>");
            out.println("<caption><h3>No actuan</h3></caption>");
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

            String sql2 = "SELECT people.* FROM people INNER JOIN act ON people.id = act.idPerson AND act.idMovie = ?";
            PreparedStatement ps2 = con2.prepareStatement(sql2);

            ps2.setString(1, movieId);

            ResultSet rs2 = ps2.executeQuery();

            out.println("<div class='container'><table align='right'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th>Accion</th></tr></thead><tbody>");
            out.println("<caption><h3>Actuan</h3></caption>");
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

            

        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * This JavaScript block contains functions for adding and deleting participants (directors) to/from a movie.
     */
    out.println("<script>");
    out.println("function addDirect(movieId, personId) {");
    out.println("    var xhr = new XMLHttpRequest();");
    out.println("    xhr.open('POST', 'index.jsp', true);");
    out.println("    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');");
    out.println("    xhr.onreadystatechange = function() {");
    out.println("        if (xhr.readyState === 4) {");
    out.println("            if (xhr.status === 200) {");
    out.println("                    location.reload();");
    out.println("                }");
    out.println("            }}");
    out.println("    xhr.send('action=addDirect&movieId=' + encodeURIComponent(movieId) + '&personId=' + encodeURIComponent(personId));");
    out.println("}");
    out.println("</script>");

    out.println("<script>");
    out.println("function deleteDirect(movieId, personId) {");
    out.println("    var xhr = new XMLHttpRequest();");
    out.println("    xhr.open('POST', 'index.jsp', true);");
    out.println("    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');");
    out.println("    xhr.onreadystatechange = function() {");
    out.println("        if (xhr.readyState === 4) {");
    out.println("            if (xhr.status === 200) {");
    out.println("                    location.reload();");
    out.println("                }");
    out.println("            }}");
    out.println("    xhr.send('action=deleteDirect&movieId=' + encodeURIComponent(movieId) + '&personId=' + encodeURIComponent(personId));");
    out.println("}");
    out.println("</script>");

    /**
     * This method generates HTML content for displaying a form to add new directors to a movie and lists existing directors of the movie.
     * If the action is "formNewDirect", it retrieves the movie ID from the request parameters,
     * queries the database to fetch existing directors who are not associated with the movie yet,
     * and displays them with an option to add them to the movie.
     * It also lists the directors already associated with the movie and provides an option to delete them.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @return The PrintWriter object for writing HTML content to the response.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
    if (action.equals("formNewDirect")){
        String movieId = request.getParameter("movieId");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT people.* FROM people LEFT JOIN direct ON people.id = direct.idPerson AND direct.idMovie = ? WHERE direct.idPerson IS NULL";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, movieId);

            ResultSet rs = ps.executeQuery();

            out.println("<div class='container'><table align='left'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th>Accion</th></tr></thead><tbody>");
            out.println("<caption><h3>No dirigen</h3></caption>");
            while (rs.next()) {
                int idPerson = rs.getInt("id");
                out.print("<tr><td>" + idPerson + "</td>");
                out.print("<td>" + rs.getString("firstname") + "</td>");
                out.print("<td>" + rs.getString("lastname") + "</td>");
                out.print("<td>" + rs.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs.getString("country") + " </td>");
                out.print("<td><img src='" + rs.getString("picture") + "' height='150px'></td>");
                out.print("<td><button onclick='addDirect(\"" + movieId + "\", \"" + idPerson + "\")'>Añadir</button></td>");
                out.print("</tr>");
            }
            
            out.println("</tbody></table>");

            out.println("</div>");

            rs.close();
            ps.close();
            con.close();

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con2 = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql2 = "SELECT people.* FROM people INNER JOIN direct ON people.id = direct.idPerson AND direct.idMovie = ?";
            PreparedStatement ps2 = con2.prepareStatement(sql2);

            ps2.setString(1, movieId);

            ResultSet rs2 = ps2.executeQuery();

            out.println("<div class='container'><table align='right'>");
            out.println("<thead><tr><th>ID</th><th>Primer Nombre</th><th>Apellidos</th><th>Año de nacimiento</th><th>Pais</th><th>Imagen</th><th>Accion</th></tr></thead><tbody>");
            out.println("<caption><h3>Dirigen</h3></caption>");
            while (rs2.next()) {
                int idPerson = rs2.getInt("id");
                out.print("<tr><td>" + rs2.getInt("id") + "</td>");
                out.print("<td>" + rs2.getString("firstname") + "</td>");
                out.print("<td>" + rs2.getString("lastname") + "</td>");
                out.print("<td>" + rs2.getInt("yearOfBirth") + "</td>");
                out.print("<td>" + rs2.getString("country") + " </td>");
                out.print("<td><img src='" + rs2.getString("picture") + "' height='150px'></td>");
                out.print("<td><button onclick='deleteDirect(\"" + movieId + "\", \"" + idPerson + "\")'>Eliminar</button></td>");
                out.print("</tr>");

            }
            
            out.println("</tbody></table>");

            out.println("</div>");

            rs2.close();
            ps2.close();
            con2.close();

            

        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }    

    /**
     * This method adds a new actor to a movie in the database.
     * If the action is "addAct", it retrieves the movie ID and actor ID from the request parameters,
     * inserts a new record into the 'act' table associating the actor with the movie.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
    if (action.equals("addAct")){
        String movieId = request.getParameter("movieId");
        String personId = request.getParameter("personId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "INSERT INTO act (idMovie, idPerson) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ps.setString(2, personId);

            int rowsAffected = ps.executeUpdate();

            ps.close();
            con.close();
            response.getWriter().write("success");
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Deletes the association between an actor and a movie from the database.
     * If the action is "deleteAct", it retrieves the movie ID and actor ID from the request parameters,
     * deletes the corresponding record from the 'act' table.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
    if (action.equals("deleteAct")){
        String movieId = request.getParameter("movieId");
        String personId = request.getParameter("personId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "DELETE FROM act WHERE idMovie = ? AND idPerson = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ps.setString(2, personId);

            int rowsAffected = ps.executeUpdate();

            ps.close();
            con.close();
            response.getWriter().write("success");
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }
    
    /**
     * Adds a new director to a movie in the database.
     * If the action is "addDirect", it retrieves the movie ID and director ID from the request parameters,
     * inserts a new record into the 'direct' table associating the director with the movie.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
    if (action.equals("addDirect")){
        String movieId = request.getParameter("movieId");
        String personId = request.getParameter("personId");

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "INSERT INTO direct (idMovie, idPerson) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ps.setString(2, personId);

            int rowsAffected = ps.executeUpdate();

            ps.close();
            con.close();
            response.getWriter().write("success");
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Deletes the association between a director and a movie from the database.
     * If the action is "deleteDirect", it retrieves the movie ID and director ID from the request parameters,
     * deletes the corresponding record from the 'direct' table.
     * 
     * @param action The action parameter from the HTTP request.
     * @param request The HttpServletRequest object containing the request parameters.
     * @throws SQLException If a database access error occurs or this method is called on a closed connection.
     */
    if (action.equals("deleteDirect")){
        String movieId = request.getParameter("movieId");
        String personId = request.getParameter("personId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "DELETE FROM direct WHERE idMovie = ? AND idPerson = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ps.setString(2, personId);

            int rowsAffected = ps.executeUpdate();

            ps.close();
            con.close();
            response.getWriter().write("success");
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }
    
    /**
     * Displays a form for creating a new movie.
     * If the action is "formNewMovie", it generates HTML code for a form to input details of a new movie,
     * including title, year, country, duration, and poster URL.
     * 
     * @param action The action parameter from the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     */
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

    /**
     * Inserts a new movie into the database.
     * If the action is "newMovie", retrieves the movie details from the HTTP request parameters,
     * including title, year, country, duration, and poster URL. Then validates and inserts
     * these details into the "movies" database table.
     *
     * @param action The action passed as a parameter in the HTTP request.
     */
    if (action.equals("newMovie")) {
        String title = request.getParameter("title");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String durationStr = request.getParameter("duration");
        String poster = request.getParameter("poster");

        try {
            int year = Integer.parseInt(yearStr);
            int duration = Integer.parseInt(durationStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "INSERT INTO movies (title, year, duration, country, poster) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, title);
            ps.setInt(2, year);
            ps.setInt(3, duration);
            ps.setString(4, country);
            ps.setString(5, poster);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp");
            }

            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    } 

    /**
     * Prepares the form to edit movie details.
     * If the action is "formEditMovie", retrieves the movie details from the database based on the provided movie ID.
     * Constructs an HTML form pre-filled with the existing movie details to allow editing.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     */
    if (action.equals("formEditMovie")) {
            String movieId = request.getParameter("movieId");
            try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT * FROM movies WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, movieId);
            ResultSet rs = ps.executeQuery();

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
            
            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Edits the details of a movie based on the provided parameters.
     * If the action is "editMovie", retrieves the movie details from the HTTP request parameters.
     * Parses the year and duration strings into integers.
     * Updates the corresponding movie record in the database with the new details.
     * Redirects to the index.jsp page after successful update.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     */
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

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

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
                response.sendRedirect("index.jsp");
            }

            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Deletes a movie from the database based on the provided movie ID.
     * If the action is "deleteMovie", retrieves the movie ID from the HTTP request parameters.
     * Deletes the corresponding movie record from the database.
     * Redirects to the index.jsp page after successful deletion.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     */
    if (action.equals("deleteMovie")) {
        String movieId = request.getParameter("movieId");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "DELETE FROM movies WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(movieId));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp");
            }

            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }


    /**************** PEOPLE *******************/
    /**
     * JavaScript form validation
    */
    out.println("<script>");
    out.println("function validatePersonForm() {");
    out.println("var name = document.getElementById('name').value;");
    out.println("var surname = document.getElementById('surname').value;");
    out.println("var year = document.getElementById('year').value;");
    out.println("var country = document.getElementById('country').value;");
    out.println("var image = document.getElementById('image').value;");
    out.println("if (name === '' || country === '' || image === '' || surname === '' || year === '') {");
    out.println("alert('Todos los campos son obligatorios');");
    out.println("return false;"); 
    out.println("}");
    out.println("if (isNaN(year)) {");
    out.println("alert('El año debe ser un número entero');");
    out.println("return false;"); 
    out.println("}");
    out.println("return true;");
    out.println("}");
    out.println("</script>");

    /**
     * Displays all people stored in the database.
     * If the action is "showAllPeople", retrieves people data from the database.
     * Generates HTML markup to display people information in a table format.
     * Provides options to add, view details, edit, and delete a person.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     */
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
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            Statement st = con.createStatement();
            String sql = "SELECT * FROM people";
            ResultSet rs = st.executeQuery(sql);

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
            
            rs.close();
            st.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Displays details of a specific person and the movies they participate in or direct.
     * If the action is "showPerson", retrieves person data and related movie information from the database.
     * Generates HTML markup to display person details and the movies they act in or direct.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     */
    if (action.equals("showPerson")) {
        String personId = request.getParameter("personId");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT * FROM people WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, personId);
            ResultSet rs = ps.executeQuery();

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
            
            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT * FROM movies INNER JOIN act ON movies.id = act.idMovie WHERE idPerson = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, personId);
            ResultSet rs = ps.executeQuery();

            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th></tr></thead><tbody>");
            out.println("<h2>Actua en<h2>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getString("id") + "</td>");
                out.print("<td>" + rs.getString("title") + "</td>");
                out.print("<td>" + rs.getString("year") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td>" + rs.getString("duration") + " min</td>");
                out.print("<td><img src='" + rs.getString("poster") + "' height='150px'></td>");
            }
            out.println("</tbody></table></div>");

            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT * FROM movies INNER JOIN direct ON movies.id = direct.idMovie WHERE idPerson = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, personId);
            ResultSet rs = ps.executeQuery();

            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th></tr></thead><tbody>");
            out.println("<h2>Dirige<h2>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getString("id") + "</td>");
                out.print("<td>" + rs.getString("title") + "</td>");
                out.print("<td>" + rs.getString("year") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td>" + rs.getString("duration") + " min</td>");
                out.print("<td><img src='" + rs.getString("poster") + "' height='150px'></td>");
            }
            out.println("</tbody></table></div>");
   
            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Displays a form for adding a new person.
     * If the action is "formNewPerson", generates HTML markup for a form to input details of a new person.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     */
    if (action.equals("formNewPerson")) {
        out.println("<div class='container'>");
        out.println("<h2>Nueva Persona</h2>");
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

    /**
     * Adds a new person to the database.
     * If the action is "newPerson", retrieves parameters from the HTTP request to create a new person entry in the database.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     */
    if (action.equals("newPerson")) {
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String image = request.getParameter("image");

        try {
            int year = Integer.parseInt(yearStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "INSERT INTO people (firstname, lastname, yearOfBirth, country, picture) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, surname);
            ps.setInt(3, year);
            ps.setString(4, country);
            ps.setString(5, image);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp");
            }

            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Displays a form to edit a person's details.
     * If the action is "formEditPerson", retrieves the person's details from the database based on the provided person ID and displays a form to edit those details.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     * @return The PrintWriter object for writing HTML content to the response.
     */
    if (action.equals("formEditPerson")) {
        String personId = request.getParameter("personId");
        try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "SELECT * FROM people WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, personId);
            ResultSet rs = ps.executeQuery();

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
            
            rs.close();
            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Edits the details of a person.
     * If the action is "editPerson", updates the details of a person in the database based on the provided person ID.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     */
    if (action.equals("editPerson")) {
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String yearStr = request.getParameter("year");
        String country = request.getParameter("country");
        String image = request.getParameter("image");
        String personId = request.getParameter("personId");

        try {
            int year = Integer.parseInt(yearStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

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
                response.sendRedirect("index.jsp");
            }

            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

    /**
     * Deletes a person from the database.
     * If the action is "deletePerson", deletes the person record from the database based on the provided person ID.
     * 
     * @param action The action passed as a parameter in the HTTP request.
     */
    if (action.equals("deletePerson")) {
        String personId = request.getParameter("personId");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");

            String sql = "DELETE FROM people WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(personId));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("index.jsp");
            }

            ps.close();
            con.close();
        } catch (SQLException e) {
            out.println("<script>alert('Error al acceder a la BD');</script>");
        }
    }

%>
<%@include file="footer.jsp" %>