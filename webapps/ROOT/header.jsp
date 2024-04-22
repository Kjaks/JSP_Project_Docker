<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Movies!</title>
<style>
body {
    font-family: "arial", helvetica;
    background-color: #ccc;
}

table {
  border-collapse: collapse; 
  border: 2px solid #444; 
  margin-left: auto; 
  margin-right: auto; 
}

th, td {
  border: 1px solid #444; 
  padding: 8px; 
}

.header {
  background-color: #209;
  color: #fff;
  padding: 20px;
  text-align: center;
}

.header h1 {
  margin: 0;
}

.header p {
  font-size: 18px;
}

.header button {
  color: #fff;
  text-decoration: none;
  padding: 5px 10px;
  border-radius: 5px;
  background-color: #555;
}

.header button:hover {
  background-color: #777;
}

.header nav form {
  display: inline-block; 
  margin-right: 10px; 
}

.container {
  margin: 20px;
  text-align: center;
}

.footer {
    text-align: center;
}


</style>
</head>
<body>

<div class="header">
  <h1>CELIA CINEMA</h1>
  <p>Las mejores peliculas en Celia Cinema!</p>
  <nav>
  
    <form action='index.jsp' method='post'>
      <button type='submit' name='action' value='showAllMovies'>Películas</button>
    </form>

    <form action='index.jsp' method='post'>
      <button type='submit' name='action' value='showAllPeople'>Personas</button>
    </form>

    <form action='index.jsp' method='post'>
      <button type='submit' name='action' value='showAllMovies'>Act</button>
    </form>

    <form action='index.jsp' method='post'>
      <button type='submit' name='action' value='showAllMovies'>Direct</button>
    </form>

  </nav>
</div>

</html>