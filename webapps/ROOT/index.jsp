<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%
        try {
            // Conectamos con la BD
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://mysql:3306/CeliaCinema", "root", "ADMIN");
            out.print("Establecida conexión con la BD");
            // Ejecutamos un SELECT
            Statement st = con.createStatement();
            String sql = "SELECT * FROM movies";
            ResultSet rs = st.executeQuery(sql);

            // Mostramos los resultados como una tabla HTML
            out.println("<div class='container'><table align='center'>");
            out.println("<thead><tr><th>ID</th><th>Título</th><th>Año</th><th>País</th><th>Duración</th><th>Cartel</th><th colspan='3'>Acciones</th></tr></thead><tbody>");
            while (rs.next()) {
                out.print("<tr><td>" + rs.getString("id") + "</td>");
                out.print("<td>" + rs.getString("title") + "</td>");
                out.print("<td>" + rs.getString("year") + "</td>");
                out.print("<td>" + rs.getString("country") + "</td>");
                out.print("<td>" + rs.getString("duration") + " min</td>");
                out.print("<td><img src='https://educacionadistancia.juntadeandalucia.es/centros/almeria/pluginfile.php/962384/mod_folder/content/0/images/" + rs.getString("poster") + "' height='150px'></td>");
                out.print("<td><a href='#'>Detalles</a></td>");
                out.print("<td><a href='#'>Modificar</a></td>");
                out.print("<td><a href='#'>Borrar</a></td></tr>");
            }
            out.println("</tbody></table></div>");
            
            // Lo cerramos todo
            rs.close();
            st.close();
            con.close();
        } catch (Exception e) {
            out.println("Error al acceder a la BD: " + e.toString());
        }
%>
</body>
</html>
