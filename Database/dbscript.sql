-- MySQL Script generated by MySQL Workbench
-- Mon Oct 12 12:36:47 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema sakila
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema sakila
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sakila` ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `data_type` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`category` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `dash_name` VARCHAR(255) NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL,
  `main_category` BIT(1) NOT NULL,
  `short_desc` TEXT NOT NULL,
  `long_desc` LONGTEXT NOT NULL,
  `category_id` INT UNSIGNED NULL,
  `image_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `fk_category_category_idx` (`category_id` ASC),
  INDEX `fk_category_image1_idx` (`image_id` ASC),
  UNIQUE INDEX `dash_name_UNIQUE` (`dash_name` ASC),
  CONSTRAINT `fk_category_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `mydb`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_category_image1`
    FOREIGN KEY (`image_id`)
    REFERENCES `mydb`.`image` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `dash_name` VARCHAR(255) NOT NULL,
  `longdesc` LONGTEXT NOT NULL,
  `shortdesc` TINYTEXT NOT NULL,
  `price` DECIMAL(65,2) NOT NULL,
  `dph` INT UNSIGNED NOT NULL,
  `active` TINYINT UNSIGNED NOT NULL,
  `amount` INT NOT NULL,
  `rating` TINYINT UNSIGNED NOT NULL,
  `category_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `fk_product_category1_idx` (`category_id` ASC),
  UNIQUE INDEX `dash_name_UNIQUE` (`dash_name` ASC),
  CONSTRAINT `fk_product_category1`
    FOREIGN KEY (`category_id`)
    REFERENCES `mydb`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`role` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `password` TINYTEXT NOT NULL,
  `orders` INT UNSIGNED NOT NULL,
  `role_id` INT UNSIGNED NOT NULL,
  `registered` TIMESTAMP NOT NULL,
  `last_active` DATE NOT NULL,
  `first_name` TINYTEXT NOT NULL,
  `last_name` TINYTEXT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC),
  INDEX `fk_user_role1_idx` (`role_id` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  CONSTRAINT `fk_user_role1`
    FOREIGN KEY (`role_id`)
    REFERENCES `mydb`.`role` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`country` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`city` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(256) NOT NULL,
  `country_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  INDEX `fk_city_country1_idx` (`country_id` ASC),
  CONSTRAINT `fk_city_country1`
    FOREIGN KEY (`country_id`)
    REFERENCES `mydb`.`country` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`invoice_adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`invoice_adress` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` TINYTEXT NULL,
  `last_name` TINYTEXT NULL,
  `firm_name` TINYTEXT NULL,
  `adress1` TINYTEXT NOT NULL,
  `adress2` TINYTEXT NOT NULL,
  `city_id` INT UNSIGNED NOT NULL,
  `zipcode` VARCHAR(12) NOT NULL,
  `DIC` VARCHAR(45) NOT NULL,
  `IC` VARCHAR(45) NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_invoice_adress_user1_idx` (`user_id` ASC),
  INDEX `fk_invoice_adress_city1_idx` (`city_id` ASC),
  CONSTRAINT `fk_invoice_adress_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_invoice_adress_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `mydb`.`city` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`shipping_adress`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`shipping_adress` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` TINYTEXT NULL,
  `last_name` TINYTEXT NULL,
  `firm_name` TINYTEXT NULL,
  `adress1` TINYTEXT NOT NULL,
  `adress2` TINYTEXT NOT NULL,
  `city_id` INT UNSIGNED NOT NULL,
  `zipcode` VARCHAR(12) NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_shipping_adress_user1_idx` (`user_id` ASC),
  INDEX `fk_shipping_adress_city1_idx` (`city_id` ASC),
  CONSTRAINT `fk_shipping_adress_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_shipping_adress_city1`
    FOREIGN KEY (`city_id`)
    REFERENCES `mydb`.`city` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`payment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `price` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`shipping`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`shipping` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `price` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user_order` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `total_price` DECIMAL(65,2) UNSIGNED NOT NULL,
  `price_without_dph` DECIMAL(65,2) UNSIGNED NOT NULL,
  `invoice_number` INT UNSIGNED NOT NULL,
  `datum_vystaveni` DATE NOT NULL,
  `datum_zdanitelneho_plneni` DATE NOT NULL,
  `datum_splatnosti` DATE NOT NULL,
  `invoice_adress_id` INT UNSIGNED NOT NULL,
  `shipping_adress_id` INT UNSIGNED NOT NULL,
  `password` VARCHAR(256) NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `payment_id` INT UNSIGNED NOT NULL,
  `shipping_id` INT UNSIGNED NOT NULL,
  `payment_status` TINYINT NOT NULL,
  `delivery_status` TINYINT NOT NULL,
  `user_note` TEXT NOT NULL,
  `shop_note` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_order_invoice_adress1_idx` (`invoice_adress_id` ASC),
  INDEX `fk_order_shipping_adress1_idx` (`shipping_adress_id` ASC),
  UNIQUE INDEX `invoice_number_UNIQUE` (`invoice_number` ASC),
  INDEX `fk_order_user1_idx` (`user_id` ASC),
  INDEX `fk_user_order_payment1_idx` (`payment_id` ASC),
  INDEX `fk_user_order_shipping1_idx` (`shipping_id` ASC),
  CONSTRAINT `fk_order_invoice_adress1`
    FOREIGN KEY (`invoice_adress_id`)
    REFERENCES `mydb`.`invoice_adress` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_shipping_adress1`
    FOREIGN KEY (`shipping_adress_id`)
    REFERENCES `mydb`.`shipping_adress` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_order_payment1`
    FOREIGN KEY (`payment_id`)
    REFERENCES `mydb`.`payment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_order_shipping1`
    FOREIGN KEY (`shipping_id`)
    REFERENCES `mydb`.`shipping` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product_has_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product_has_order` (
  `user_order_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `price` DECIMAL(65,2) NOT NULL,
  `amount` INT UNSIGNED NOT NULL,
  `discount` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_order_id`, `product_id`),
  INDEX `fk_product_has_order_order1_idx` (`user_order_id` ASC),
  INDEX `fk_product_has_order_product1_idx` (`product_id` ASC),
  CONSTRAINT `fk_product_has_order_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_has_order_order1`
    FOREIGN KEY (`user_order_id`)
    REFERENCES `mydb`.`user_order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`eshop_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`eshop_info` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firm_name` VARCHAR(256) NOT NULL,
  `adress1` VARCHAR(256) NOT NULL,
  `adress2` VARCHAR(256) NOT NULL,
  `city` VARCHAR(256) NOT NULL,
  `country` VARCHAR(256) NOT NULL,
  `zipcode` VARCHAR(12) NOT NULL,
  `DIC` VARCHAR(45) NOT NULL,
  `IC` VARCHAR(45) NOT NULL,
  `admin_password` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`image_has_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`image_has_product` (
  `image_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `main_image` BIT(1) NOT NULL,
  PRIMARY KEY (`image_id`, `product_id`),
  INDEX `fk_image_has_product_product1_idx` (`product_id` ASC),
  INDEX `fk_image_has_product_image1_idx` (`image_id` ASC),
  CONSTRAINT `fk_image_has_product_image1`
    FOREIGN KEY (`image_id`)
    REFERENCES `mydb`.`image` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_image_has_product_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`parameter`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`parameter` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `type` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`parameter_has_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`parameter_has_product` (
  `parameter_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `value` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`parameter_id`, `product_id`),
  INDEX `fk_parameter_has_product_product1_idx` (`product_id` ASC),
  INDEX `fk_parameter_has_product_parameter1_idx` (`parameter_id` ASC),
  CONSTRAINT `fk_parameter_has_product_parameter1`
    FOREIGN KEY (`parameter_id`)
    REFERENCES `mydb`.`parameter` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parameter_has_product_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`discount`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`discount` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `amount` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `from_date` DATE NULL,
  `to_date` DATE NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_discount_product1_idx` (`product_id` ASC),
  CONSTRAINT `fk_discount_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`storage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`storage` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `last_amount` INT NOT NULL,
  `new_amount` INT NOT NULL,
  `movement` INT NOT NULL,
  `timestamp` TIMESTAMP NOT NULL,
  `type` ENUM("sold", "inventura") NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_storage_product1_idx` (`product_id` ASC),
  CONSTRAINT `fk_storage_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`shopping_cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`shopping_cart` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `amount` INT UNSIGNED NOT NULL,
  `price` DECIMAL(65,2) UNSIGNED NOT NULL,
  `updated` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_shopping_cart_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_shopping_cart_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`product_has_shopping_cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product_has_shopping_cart` (
  `product_id` INT UNSIGNED NOT NULL,
  `shopping_cart_id` INT UNSIGNED NOT NULL,
  `amount` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`product_id`, `shopping_cart_id`),
  INDEX `fk_product_has_shopping_cart_shopping_cart1_idx` (`shopping_cart_id` ASC),
  INDEX `fk_product_has_shopping_cart_product1_idx` (`product_id` ASC),
  CONSTRAINT `fk_product_has_shopping_cart_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_product_has_shopping_cart_shopping_cart1`
    FOREIGN KEY (`shopping_cart_id`)
    REFERENCES `mydb`.`shopping_cart` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`price`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`price` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_id` INT UNSIGNED NOT NULL,
  `last_price` DECIMAL(65,2) NOT NULL,
  `new_price` DECIMAL(65,2) NOT NULL,
  `movement` DECIMAL(65,2) NOT NULL,
  `timestamp` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_price_product1_idx` (`product_id` ASC),
  CONSTRAINT `fk_price_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`chat_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`chat_session` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created` TIMESTAMP NOT NULL,
  `last_message` DATE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`message` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `message` TEXT NOT NULL,
  `created` TIMESTAMP NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `chat_session_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `chat_session_id`),
  INDEX `fk_message_user1_idx` (`user_id` ASC),
  INDEX `fk_message_chat_session1_idx` (`chat_session_id` ASC),
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_chat_session1`
    FOREIGN KEY (`chat_session_id`)
    REFERENCES `mydb`.`chat_session` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_has_chat_session`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user_has_chat_session` (
  `user_id` INT UNSIGNED NOT NULL,
  `chat_session_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `chat_session_id`),
  INDEX `fk_user_has_chat_session_chat_session1_idx` (`chat_session_id` ASC),
  INDEX `fk_user_has_chat_session_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_has_chat_session_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_chat_session_chat_session1`
    FOREIGN KEY (`chat_session_id`)
    REFERENCES `mydb`.`chat_session` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`rating`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`rating` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `value` TINYINT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `user_id`, `product_id`),
  INDEX `fk_rating_product1_idx` (`product_id` ASC),
  INDEX `fk_rating_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_rating_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_rating_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`comment` (
  `id` INT NOT NULL,
  `text` MEDIUMTEXT NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_comment_product1_idx` (`product_id` ASC),
  INDEX `fk_comment_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_comment_product1`
    FOREIGN KEY (`product_id`)
    REFERENCES `mydb`.`product` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`announcements`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`announcements` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(128) NOT NULL,
  `description` LONGTEXT NOT NULL,
  `short_desc` TINYTEXT NOT NULL,
  `DATE` TIMESTAMP NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`mailist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`mailist` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`offer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`offer` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` TINYTEXT NOT NULL,
  `description` LONGTEXT NOT NULL,
  `short_desc` TINYTEXT NOT NULL,
  `conditions` MEDIUMTEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`offer_code`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`offer_code` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` TINYTEXT NOT NULL,
  `description` TEXT NOT NULL,
  `short_desc` TINYTEXT NOT NULL,
  `code` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

USE `sakila` ;
USE `mydb` ;

-- -----------------------------------------------------
-- procedure film_in_stock
-- -----------------------------------------------------

DELIMITER $$
USE `sakila`$$
CREATE PROCEDURE `sakila`.`film_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure film_not_in_stock
-- -----------------------------------------------------

DELIMITER $$
USE `sakila`$$
CREATE PROCEDURE `sakila`.`film_not_in_stock`(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT FOUND_ROWS() INTO p_film_count;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_products
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_products`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
     DELETE FROM parameter_has_product;
     DELETE FROM image_has_product;
     DELETE FROM image;
     DELETE FROM price;
     DELETE FROM storage;
     DELETE FROM discount;
     DELETE FROM product;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_products
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_products`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
     DELETE FROM parameter_has_product;
     DELETE FROM image_has_product;
     DELETE FROM image;
     DELETE FROM price;
     DELETE FROM storage;
     DELETE FROM discount;
     DELETE FROM product;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_orders
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_orders`()
READS SQL DATA
BEGIN
	 DELETE FROM product_has_order;
     DELETE FROM user_order;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_carts
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_carts`()
READS SQL DATA
BEGIN
	 DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_chats
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_chats`()
READS SQL DATA
BEGIN
	 DELETE FROM user_has_chat_session;
     DELETE FROM message;
     DELETE FROM chat_session;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_subcategories
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_subcategories`()
READS SQL DATA
BEGIN
	 DELETE FROM category WHERE main_category = 0;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_users
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_users`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM user_has_chat_session;
	 DELETE FROM message;
     DELETE FROM chat_session;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM invoice_adress;
     DELETE FROM shipping_adress;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_products
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_products`()
READS SQL DATA
BEGIN
	 DELETE FROM rating;
	 DELETE FROM comment;
     DELETE FROM product_has_order; 
     DELETE FROM user_order;
     DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
     DELETE FROM parameter_has_product;
     DELETE FROM image_has_product;
     DELETE FROM image;
     DELETE FROM price;
     DELETE FROM storage;
     DELETE FROM discount;
     DELETE FROM product;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_orders
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_orders`()
READS SQL DATA
BEGIN
	 DELETE FROM product_has_order;
     DELETE FROM user_order;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_carts
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_carts`()
READS SQL DATA
BEGIN
	 DELETE FROM product_has_shopping_cart;
     DELETE FROM shopping_cart;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_chats
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_chats`()
READS SQL DATA
BEGIN
	 DELETE FROM user_has_chat_session;
     DELETE FROM message;
     DELETE FROM chat_session;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_subcategories
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `mydb`.`delete_subcategories`()
READS SQL DATA
BEGIN
	 DELETE FROM category WHERE main_category = 0;
END$$

DELIMITER ;
USE `mydb`;

DELIMITER $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`product_AFTER_INSERT` AFTER INSERT ON `product` FOR EACH ROW
BEGIN
INSERT INTO discount(amount,product_id) VALUES (0,new.id);
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;