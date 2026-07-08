<?php
$rqt = "SELECT *
        FROM view_stats_journalieres
        WHERE restaurant_id = 1 AND date_stat = CURDATE()";

$result = $conn->query($rqt);
if (!$result) {
    echo "La requête SQL a échoué ! L'erreur est : " . $conn->error;
    exit(); // Arrête le script pour voir l'erreur
}
$rqt2 = "SELECT *
        FROM view_dashboard_performances
        WHERE restaurant_id = 1 ";

$result2 = $conn->query($rqt2);
if (!$result2) {
    echo "La requête SQL a échoué ! L'erreur est : " . $conn->error;
    exit(); // Arrête le script pour voir l'erreur
}
?>