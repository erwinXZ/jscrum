<?php
    $nombre = $_POST['email'];
    move_uploaded_file($_FILES['imagen']['tmp_name'],'../images/users/'.$nombre); 
?>          