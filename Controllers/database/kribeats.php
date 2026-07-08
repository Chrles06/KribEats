<?php
$Host = "localhost";
$User = "root";
$Pass = "";
$DbName = "kribeats";

// Test connexion
$conn = new mysqli($Host, $User, $Pass, $DbName);

if ($conn->connect_error) {
    die("Erreur de connexion : " . $conn->connect_error);
}
?>