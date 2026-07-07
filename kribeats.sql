-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 07 juil. 2026 à 07:53
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `kribeats`
--

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `nom_categorie` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `categorie_id` int(11) NOT NULL,
  `nom_plat` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `prix` int(11) NOT NULL,
  `disponible` tinyint(1) DEFAULT 1,
  `image_url` varchar(255) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `adresse_livraison` text NOT NULL,
  `telephone_contact` varchar(20) NOT NULL,
  `mode_paiement` enum('momo','orange_money','cash') NOT NULL,
  `statut_paiement` enum('en_attente','valide','echoue') DEFAULT 'en_attente',
  `statut_commande` enum('recue','preparation','livraison','livree','annulee') DEFAULT 'recue',
  `total_commande` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `livree_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantite` int(11) NOT NULL DEFAULT 1,
  `prix_unitaire` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `restaurants`
--

CREATE TABLE `restaurants` (
  `id` int(11) NOT NULL,
  `proprietaire_id` int(11) NOT NULL,
  `nom_restaurant` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `quartier` varchar(100) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `restaurant_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `note` int(11) NOT NULL COMMENT 'Note de 1 à 5',
  `commentaire` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telephone` varchar(20) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `role` enum('client','restaurateur','admin','livreur') DEFAULT 'client',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `view_dashboard_performances`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_dashboard_performances` (
`restaurant_id` int(11)
,`nom_restaurant` varchar(150)
,`note_moyenne` decimal(12,1)
,`delai_moyen_minutes` decimal(21,0)
,`revenu_total` decimal(32,0)
,`total_commandes_livrees` bigint(21)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `view_performance_plats`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_performance_plats` (
`nom_plat` varchar(150)
,`nombre_ventes` decimal(32,0)
,`revenu_genere` decimal(42,0)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `view_repartition_paiements`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_repartition_paiements` (
`mode_paiement` enum('momo','orange_money','cash')
,`nombre_transactions` bigint(21)
,`pourcentage` decimal(28,5)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `view_stats_journalieres`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_stats_journalieres` (
`restaurant_id` int(11)
,`date_stat` date
,`total_commandes` bigint(21)
,`revenu_total` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Structure de la vue `view_dashboard_performances`
--
DROP TABLE IF EXISTS `view_dashboard_performances`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_dashboard_performances`  AS SELECT `r`.`id` AS `restaurant_id`, `r`.`nom_restaurant` AS `nom_restaurant`, round(avg(`rev`.`note`),1) AS `note_moyenne`, round(avg(timestampdiff(MINUTE,`o`.`created_at`,`o`.`livree_at`)),0) AS `delai_moyen_minutes`, coalesce(sum(`o`.`total_commande`),0) AS `revenu_total`, count(`o`.`id`) AS `total_commandes_livrees` FROM ((`restaurants` `r` left join `orders` `o` on(`r`.`id` = `o`.`restaurant_id` and `o`.`statut_commande` = 'livree')) left join `reviews` `rev` on(`r`.`id` = `rev`.`restaurant_id`)) GROUP BY `r`.`id`, `r`.`nom_restaurant` ;

-- --------------------------------------------------------

--
-- Structure de la vue `view_performance_plats`
--
DROP TABLE IF EXISTS `view_performance_plats`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_performance_plats`  AS SELECT `m`.`nom_plat` AS `nom_plat`, sum(`oi`.`quantite`) AS `nombre_ventes`, sum(`oi`.`quantite` * `oi`.`prix_unitaire`) AS `revenu_genere` FROM ((`menu_items` `m` join `order_items` `oi` on(`m`.`id` = `oi`.`menu_item_id`)) join `orders` `o` on(`oi`.`order_id` = `o`.`id`)) WHERE `o`.`statut_commande` = 'livree' GROUP BY `m`.`id` ORDER BY sum(`oi`.`quantite`) DESC ;

-- --------------------------------------------------------

--
-- Structure de la vue `view_repartition_paiements`
--
DROP TABLE IF EXISTS `view_repartition_paiements`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_repartition_paiements`  AS SELECT `orders`.`mode_paiement` AS `mode_paiement`, count(`orders`.`id`) AS `nombre_transactions`, count(`orders`.`id`) * 100.0 / sum(count(`orders`.`id`)) over () AS `pourcentage` FROM `orders` GROUP BY `orders`.`mode_paiement` ;

-- --------------------------------------------------------

--
-- Structure de la vue `view_stats_journalieres`
--
DROP TABLE IF EXISTS `view_stats_journalieres`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_stats_journalieres`  AS SELECT `orders`.`restaurant_id` AS `restaurant_id`, cast(`orders`.`created_at` as date) AS `date_stat`, count(`orders`.`id`) AS `total_commandes`, sum(`orders`.`total_commande`) AS `revenu_total` FROM `orders` WHERE `orders`.`statut_commande` = 'livree' GROUP BY `orders`.`restaurant_id`, cast(`orders`.`created_at` as date) ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nom_categorie` (`nom_categorie`);

--
-- Index pour la table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `restaurant_id` (`restaurant_id`),
  ADD KEY `categorie_id` (`categorie_id`);

--
-- Index pour la table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `client_id` (`client_id`),
  ADD KEY `restaurant_id` (`restaurant_id`);

--
-- Index pour la table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_item_id` (`menu_item_id`);

--
-- Index pour la table `restaurants`
--
ALTER TABLE `restaurants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proprietaire_id` (`proprietaire_id`);

--
-- Index pour la table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `restaurant_id` (`restaurant_id`),
  ADD KEY `client_id` (`client_id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `restaurants`
--
ALTER TABLE `restaurants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `menu_items_ibfk_2` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`);

--
-- Contraintes pour la table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`);

--
-- Contraintes pour la table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Contraintes pour la table `restaurants`
--
ALTER TABLE `restaurants`
  ADD CONSTRAINT `restaurants_ibfk_1` FOREIGN KEY (`proprietaire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
