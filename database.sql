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
