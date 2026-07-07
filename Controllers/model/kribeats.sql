-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 07 juil. 2026 à 10:09
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30
SET
  SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET
  time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;

/*!40101 SET NAMES utf8mb4 */
;

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Déchargement des données de la table `categories`
--
INSERT INTO
  `categories` (`id`, `nom_categorie`)
VALUES
  (3, 'Accompagnements'),
  (4, 'Boissons'),
  (2, 'Plats Résistants'),
  (1, 'Poissons & Crustacés');

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Déchargement des données de la table `menu_items`
--
INSERT INTO
  `menu_items` (
    `id`,
    `restaurant_id`,
    `categorie_id`,
    `nom_plat`,
    `description`,
    `prix`,
    `disponible`,
    `image_url`,
    `updated_at`
  )
VALUES
  (
    1,
    1,
    1,
    'Bar Braisé Moyen',
    'Poisson bar frais pêché à Kribi, braisé au feu de bois avec ses épices.',
    4500,
    1,
    'uploads/menu/bar_braise.jpg',
    '2026-07-07 06:43:50'
  ),
  (
    2,
    1,
    3,
    'Portion de frites de plantain',
    'Plantains mûrs frits, dorés et croustillants.',
    1000,
    1,
    'uploads/menu/plantains.jpg',
    '2026-07-07 06:43:50'
  ),
  (
    3,
    1,
    4,
    'Jus de Bissap Glacé',
    'Boisson maison naturelle parfumée à la menthe.',
    500,
    1,
    'uploads/menu/bissap.jpg',
    '2026-07-07 06:43:50'
  ),
  (
    4,
    2,
    2,
    'Poulet DG Royal',
    'Mijoté de poulet aux plantains frits, légumes croquants et aromates.',
    3500,
    1,
    'uploads/menu/poulet_dg.jpg',
    '2026-07-07 06:43:50'
  ),
  (
    5,
    2,
    2,
    'Ndolé aux Crevettes',
    'Plat traditionnel à base de feuilles de ndolé, arachides et crevettes fraîches.',
    4000,
    1,
    'uploads/menu/ndole.jpg',
    '2026-07-07 06:43:50'
  );

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
  `mode_paiement` enum('momo', 'orange_money', 'cash') NOT NULL,
  `statut_paiement` enum('en_attente', 'valide', 'echoue') DEFAULT 'en_attente',
  `statut_commande` enum(
    'recue',
    'preparation',
    'livraison',
    'livree',
    'annulee'
  ) DEFAULT 'recue',
  `total_commande` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `livree_at` timestamp NULL DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Déchargement des données de la table `orders`
--
INSERT INTO
  `orders` (
    `id`,
    `client_id`,
    `restaurant_id`,
    `adresse_livraison`,
    `telephone_contact`,
    `mode_paiement`,
    `statut_paiement`,
    `statut_commande`,
    `total_commande`,
    `created_at`,
    `livree_at`
  )
VALUES
  (
    1,
    2,
    1,
    'Entrée Débarcadère, Kribi',
    '699445566',
    'momo',
    'valide',
    'livree',
    5500,
    '2026-07-06 11:00:00',
    '2026-07-06 11:35:00'
  ),
  (
    2,
    3,
    1,
    'Hôtel Pharaon, Quartier Mpangou',
    '655778899',
    'orange_money',
    'valide',
    'livree',
    10000,
    '2026-07-06 18:30:00',
    '2026-07-06 19:15:00'
  ),
  (
    3,
    2,
    1,
    'Quartier Talla, face pharmacie',
    '699445566',
    'cash',
    'valide',
    'livree',
    4000,
    '2026-07-07 05:10:00',
    '2026-07-07 12:35:00'
  ),
  (
    4,
    3,
    1,
    'Carrefour King Döner, Dombé',
    '655778899',
    'momo',
    'en_attente',
    'livree',
    5000,
    '2026-07-07 07:48:00',
    NULL
  );

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Déchargement des données de la table `order_items`
--
INSERT INTO
  `order_items` (
    `id`,
    `order_id`,
    `menu_item_id`,
    `quantite`,
    `prix_unitaire`
  )
VALUES
  (1, 1, 1, 1, 4500),
  (2, 1, 2, 1, 1000),
  (3, 2, 1, 2, 4500),
  (4, 2, 3, 2, 500),
  (5, 3, 5, 1, 4000),
  (6, 4, 4, 1, 3500),
  (7, 4, 2, 1, 1000),
  (8, 4, 3, 1, 500);

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Déchargement des données de la table `restaurants`
--
INSERT INTO
  `restaurants` (
    `id`,
    `proprietaire_id`,
    `nom_restaurant`,
    `description`,
    `quartier`,
    `image_url`,
    `created_at`
  )
VALUES
  (
    1,
    1,
    'La Grillade Kribienne',
    'Spécialités de poissons braisés et fruits de mer frais de l\'océan.',
    'Dombé',
    'uploads/restaurants/grillade.jpg',
    '2026-05-11 10:30:00'
  ),
  (
    2,
    1,
    'Saveurs Afro-Fusion',
    'Le meilleur du Poulet DG et des plats traditionnels revisités.',
    'Quartier Ngollé',
    'uploads/restaurants/afro_fusion.jpg',
    '2026-05-15 15:00:00'
  );

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
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

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
  `role` enum('client', 'restaurateur', 'admin', 'livreur') DEFAULT 'client',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--
INSERT INTO
  `users` (
    `id`,
    `nom`,
    `email`,
    `telephone`,
    `mot_de_passe`,
    `role`,
    `created_at`
  )
VALUES
  (
    1,
    'Pierre Mvondo',
    'pierre.mvondo@email.com',
    '677112233',
    '$2y$10$xyz...',
    'restaurateur',
    '2026-05-10 09:00:00'
  ),
  (
    2,
    'Alice Ngo',
    'alice.ngo@email.com',
    '699445566',
    '$2y$10$xyz...',
    'client',
    '2026-06-01 13:20:00'
  ),
  (
    3,
    'Jean Kamga',
    'jean.kamga@email.com',
    '655778899',
    '$2y$10$xyz...',
    'client',
    '2026-06-15 08:15:00'
  ),
  (
    4,
    'Samuel Ewane',
    'samuel.livreur@email.com',
    '688001122',
    '$2y$10$xyz...',
    'livreur',
    '2026-06-20 10:00:00'
  ),
  (
    5,
    'Admin KribEats',
    'admin@kribeats.com',
    '670111222',
    '$2y$10$xyz...',
    'admin',
    '2026-05-01 07:00:00'
  );

-- --------------------------------------------------------
--
-- Doublure de structure pour la vue `view_dashboard_performances`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_dashboard_performances` (
  `restaurant_id` int(11),
  `nom_restaurant` varchar(150),
  `note_moyenne` decimal(12, 1),
  `delai_moyen_minutes` decimal(21, 0),
  `revenu_total` decimal(32, 0),
  `total_commandes_livrees` bigint(21)
);

-- --------------------------------------------------------
--
-- Doublure de structure pour la vue `view_performance_plats`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_performance_plats` (
  `nom_plat` varchar(150),
  `nombre_ventes` decimal(32, 0),
  `revenu_genere` decimal(42, 0)
);

-- --------------------------------------------------------
--
-- Doublure de structure pour la vue `view_repartition_paiements`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_repartition_paiements` (
  `mode_paiement` enum('momo', 'orange_money', 'cash'),
  `nombre_transactions` bigint(21),
  `pourcentage` decimal(28, 5)
);

-- --------------------------------------------------------
--
-- Doublure de structure pour la vue `view_stats_journalieres`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `view_stats_journalieres` (
  `restaurant_id` int(11),
  `date_stat` date,
  `total_commandes` bigint(21),
  `revenu_total` decimal(32, 0)
);

-- --------------------------------------------------------
--
-- Structure de la vue `view_dashboard_performances`
--
DROP TABLE IF EXISTS `view_dashboard_performances`;

CREATE ALGORITHM = UNDEFINED DEFINER = `root` @`localhost` SQL SECURITY DEFINER VIEW `view_dashboard_performances` AS
SELECT
  `r`.`id` AS `restaurant_id`,
  `r`.`nom_restaurant` AS `nom_restaurant`,
  round(avg(`rev`.`note`), 1) AS `note_moyenne`,
  round(
    avg(
      timestampdiff(MINUTE, `o`.`created_at`, `o`.`livree_at`)
    ),
    0
  ) AS `delai_moyen_minutes`,
  coalesce(sum(`o`.`total_commande`), 0) AS `revenu_total`,
  count(`o`.`id`) AS `total_commandes_livrees`
FROM
  (
    (
      `restaurants` `r`
      left join `orders` `o` on(
        `r`.`id` = `o`.`restaurant_id`
        and `o`.`statut_commande` = 'livree'
      )
    )
    left join `reviews` `rev` on(`r`.`id` = `rev`.`restaurant_id`)
  )
GROUP BY
  `r`.`id`,
  `r`.`nom_restaurant`;

-- --------------------------------------------------------
--
-- Structure de la vue `view_performance_plats`
--
DROP TABLE IF EXISTS `view_performance_plats`;

CREATE ALGORITHM = UNDEFINED DEFINER = `root` @`localhost` SQL SECURITY DEFINER VIEW `view_performance_plats` AS
SELECT
  `m`.`nom_plat` AS `nom_plat`,
  sum(`oi`.`quantite`) AS `nombre_ventes`,
  sum(`oi`.`quantite` * `oi`.`prix_unitaire`) AS `revenu_genere`
FROM
  (
    (
      `menu_items` `m`
      join `order_items` `oi` on(`m`.`id` = `oi`.`menu_item_id`)
    )
    join `orders` `o` on(`oi`.`order_id` = `o`.`id`)
  )
WHERE
  `o`.`statut_commande` = 'livree'
GROUP BY
  `m`.`id`
ORDER BY
  sum(`oi`.`quantite`) DESC;

-- --------------------------------------------------------
--
-- Structure de la vue `view_repartition_paiements`
--
DROP TABLE IF EXISTS `view_repartition_paiements`;

CREATE ALGORITHM = UNDEFINED DEFINER = `root` @`localhost` SQL SECURITY DEFINER VIEW `view_repartition_paiements` AS
SELECT
  `orders`.`mode_paiement` AS `mode_paiement`,
  count(`orders`.`id`) AS `nombre_transactions`,
  count(`orders`.`id`) * 100.0 / sum(count(`orders`.`id`)) over () AS `pourcentage`
FROM
  `orders`
GROUP BY
  `orders`.`mode_paiement`;

-- --------------------------------------------------------
--
-- Structure de la vue `view_stats_journalieres`
--
DROP TABLE IF EXISTS `view_stats_journalieres`;

CREATE ALGORITHM = UNDEFINED DEFINER = `root` @`localhost` SQL SECURITY DEFINER VIEW `view_stats_journalieres` AS
SELECT
  `orders`.`restaurant_id` AS `restaurant_id`,
  cast(`orders`.`created_at` as date) AS `date_stat`,
  count(`orders`.`id`) AS `total_commandes`,
  sum(`orders`.`total_commande`) AS `revenu_total`
FROM
  `orders`
WHERE
  `orders`.`statut_commande` = 'livree'
GROUP BY
  `orders`.`restaurant_id`,
  cast(`orders`.`created_at` as date);

--
-- Index pour les tables déchargées
--
--
-- Index pour la table `categories`
--
ALTER TABLE
  `categories`
ADD
  PRIMARY KEY (`id`),
ADD
  UNIQUE KEY `nom_categorie` (`nom_categorie`);

--
-- Index pour la table `menu_items`
--
ALTER TABLE
  `menu_items`
ADD
  PRIMARY KEY (`id`),
ADD
  KEY `restaurant_id` (`restaurant_id`),
ADD
  KEY `categorie_id` (`categorie_id`);

--
-- Index pour la table `orders`
--
ALTER TABLE
  `orders`
ADD
  PRIMARY KEY (`id`),
ADD
  KEY `client_id` (`client_id`),
ADD
  KEY `restaurant_id` (`restaurant_id`);

--
-- Index pour la table `order_items`
--
ALTER TABLE
  `order_items`
ADD
  PRIMARY KEY (`id`),
ADD
  KEY `order_id` (`order_id`),
ADD
  KEY `menu_item_id` (`menu_item_id`);

--
-- Index pour la table `restaurants`
--
ALTER TABLE
  `restaurants`
ADD
  PRIMARY KEY (`id`),
ADD
  KEY `proprietaire_id` (`proprietaire_id`);

--
-- Index pour la table `reviews`
--
ALTER TABLE
  `reviews`
ADD
  PRIMARY KEY (`id`),
ADD
  KEY `order_id` (`order_id`),
ADD
  KEY `restaurant_id` (`restaurant_id`),
ADD
  KEY `client_id` (`client_id`);

--
-- Index pour la table `users`
--
ALTER TABLE
  `users`
ADD
  PRIMARY KEY (`id`),
ADD
  UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--
--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE
  `categories`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 5;

--
-- AUTO_INCREMENT pour la table `menu_items`
--
ALTER TABLE
  `menu_items`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 6;

--
-- AUTO_INCREMENT pour la table `orders`
--
ALTER TABLE
  `orders`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 5;

--
-- AUTO_INCREMENT pour la table `order_items`
--
ALTER TABLE
  `order_items`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 9;

--
-- AUTO_INCREMENT pour la table `restaurants`
--
ALTER TABLE
  `restaurants`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 3;

--
-- AUTO_INCREMENT pour la table `reviews`
--
ALTER TABLE
  `reviews`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE
  `users`
MODIFY
  `id` int(11) NOT NULL AUTO_INCREMENT,
  AUTO_INCREMENT = 6;

--
-- Contraintes pour les tables déchargées
--
--
-- Contraintes pour la table `menu_items`
--
ALTER TABLE
  `menu_items`
ADD
  CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
ADD
  CONSTRAINT `menu_items_ibfk_2` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`);

--
-- Contraintes pour la table `orders`
--
ALTER TABLE
  `orders`
ADD
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`),
ADD
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`);

--
-- Contraintes pour la table `order_items`
--
ALTER TABLE
  `order_items`
ADD
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
ADD
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);

--
-- Contraintes pour la table `restaurants`
--
ALTER TABLE
  `restaurants`
ADD
  CONSTRAINT `restaurants_ibfk_1` FOREIGN KEY (`proprietaire_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reviews`
--
ALTER TABLE
  `reviews`
ADD
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
ADD
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurants` (`id`) ON DELETE CASCADE,
ADD
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;