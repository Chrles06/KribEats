CREATE DATABASE IF NOT EXISTS KribEats;

USE KribEats;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telephone VARCHAR(20) NOT NULL, -- Format Cameroun (+237...)
    mot_de_passe VARCHAR(255) NOT NULL, -- Version hachée (password_hash)
    role ENUM('client', 'restaurateur', 'admin', 'livreur') DEFAULT 'client',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE restaurants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proprietaire_id INT NOT NULL,
    nom_restaurant VARCHAR(150) NOT NULL,
    description TEXT,
    quartier VARCHAR(100) NOT NULL, -- Ex: Quartier Tontine, Beach Side...
    image_url VARCHAR(255), -- Chemin vers le logo ou l'emoji représentatif
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (proprietaire_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

--pour permettre aux restaurateurs de créer des catégories pour leurs plats, du genre: Entrées, Plats, Desserts, Boissons, etc.
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_categorie VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

--C'est ici que les restaurateurs gerent le CRUD de leurs menus. pour eviter les collision de panier, chaque plat appartient a un restaurant precis.
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    categorie_id INT NOT NULL,
    nom_plat VARCHAR(150) NOT NULL,
    description TEXT,
    prix INT NOT NULL, -- Prix en FCFA 
    disponible BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    FOREIGN KEY (categorie_id) REFERENCES categories(id)
) ENGINE=InnoDB;

--Cette table centralise la commande globale d'un client, son mode de paiement et son statut de tracking
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    restaurant_id INT NOT NULL, -- Permet au restaurateur de voir uniquement ses commandes
    adresse_livraison TEXT NOT NULL,
    telephone_contact VARCHAR(20) NOT NULL,
    mode_paiement ENUM('momo', 'orange_money', 'cash') NOT NULL,
    statut_paiement ENUM('en_attente', 'valide', 'echoue') DEFAULT 'en_attente',
    statut_commande ENUM('recue', 'preparation', 'livraison', 'livree', 'annulee') DEFAULT 'recue',
    total_commande INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES users(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
) ENGINE=InnoDB;

--(Détails de la Commande).
--Une commande peut contenir plusieurs plats en plusieurs quantités. C'est la table d'association (Relation Many-to-Many entre orders et menu_items).
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantite INT NOT NULL DEFAULT 1,
    prix_unitaire INT NOT NULL, -- On stocke le prix au moment de l'achat (au cas où le resto change ses prix plus tard)
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
) ENGINE=InnoDB;

