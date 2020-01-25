/*
Написать скрипт, добавляющий в БД vk, 
которую создали на занятии, 
3 новые таблицы (с перечнем полей, 
указанием индексов и внешних ключей)
*/

DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;
USE vk;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
    phone BIGINT, 
    INDEX users_phone_idx(phone),
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX (user_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

-- новые таблицы по ДЗ
-- таблиза взаимоотношений между 2мя пользователями (запрос\любовь\брак\отклонен\)
DROP TABLE IF EXISTS `relations`;
CREATE TABLE `relations` (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'in love', 'marriage', 'declined'),
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);

-- таблиза родственных связей (запрос\брат-сестра\родители-дети\отклонен)
DROP TABLE IF EXISTS `relatives`;
CREATE TABLE `relatives` (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'sister/brother', 'parents\children', 'declined'),
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME DEFAULT NOW(),
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)
);

-- таблица комментарии

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
	id SERIAL PRIMARY KEY,
	comment_to_id BIGINT UNSIGNED NOT NULL, -- что комментируется
    user_id BIGINT UNSIGNED NOT NULL, -- кто комментирует
	media_id BIGINT UNSIGNED NOT NULL, -- сам комментарий
    INDEX (user_id), 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (comment_to_id) REFERENCES media(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);
