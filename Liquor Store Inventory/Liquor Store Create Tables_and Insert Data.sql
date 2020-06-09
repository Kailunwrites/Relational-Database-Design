
DROP DATABASE   IF     EXISTS `liquor_store_draft`;

CREATE SCHEMA IF NOT EXISTS `liquor_store_draft` ;
USE `liquor_store_draft` ;

-- -----------------------------------------------------
-- Table `liquor_store_draft`.`zip_code`
-- -----------------------------------------------------
CREATE TABLE liquor_store_draft.`zip_code`(
  `code` VARCHAR(5) NOT NULL ,
  `city_boro` VARCHAR(50) NULL,
  `city` VARCHAR(45) NOT NULL,
  `state_code` VARCHAR(2) NOT NULL,
  PRIMARY KEY (`code`)
  )
;

-- -----------------------------------------------------
-- Table `liquor_store_draft`.`customer_address`
-- -----------------------------------------------------
CREATE TABLE liquor_store_draft.`customer_address`
(
  `address_id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `apt_no` VARCHAR(45) NULL DEFAULT NULL,
  `street_number` INT NULL,
  `street` VARCHAR(50) NOT NULL,
   `town` VARCHAR(50) NULL,
  `zip_code` VARCHAR(5) NULL,
  `phone_no` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`address_id`),
  CONSTRAINT `fk_customer_address_zipcode`
    FOREIGN KEY (`zip_code`)
    REFERENCES `zip_code` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
;
-- -----------------------------------------------------
-- Table `liquor_store_draft`.`store`
-- -----------------------------------------------------
CREATE TABLE `store` (
  `store_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`store_id`)
  )
;


-- -----------------------------------------------------
-- Table `liquor_store_draft`.`customer`
-- -----------------------------------------------------
CREATE TABLE `customer` (
  `customer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `store_id` TINYINT UNSIGNED NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) NULL DEFAULT NULL,
  `address_id` SMALLINT UNSIGNED NOT NULL,
  `recent_purchase` DATETIME NOT NULL,
  `birthday` DATE NOT NULL,
  PRIMARY KEY (`customer_id`),
  INDEX `idx_fk_store_id` (`store_id` ASC),
  INDEX `idx_fk_address_id` (`address_id` ASC),
  INDEX `idx_last_name` (`last_name` ASC),
  CONSTRAINT `fk_customer_address`
    FOREIGN KEY (`address_id`)
    REFERENCES `customer_address` (`address_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_customer_store`
    FOREIGN KEY (`store_id`)
    REFERENCES `store` (`store_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
;

-- -----------------------------------------------------
-- Table `liquor_store_draft`.`customer_recommended_liquor`
-- -----------------------------------------------------
CREATE TABLE `customer_recommended_liquor` (
`customer_recommended_liquor_id` INT UNSIGNED NOT NULL AUTO_INCREMENT, 
  `customer_id` INT UNSIGNED NOT NULL,
  `description_type` VARCHAR(45) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `status` char(3) NOT NULL,
  INDEX `fk_customer_recommended_liquor_customer_idx` (`customer_recommended_liquor_id` ASC),
  PRIMARY KEY (`customer_recommended_liquor_id`),
  CONSTRAINT `fk_customer_recommended_liquor_customer`
    FOREIGN KEY (`customer_id`)
    REFERENCES `customer` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table `liquor_store_draft`.`employee`
-- -----------------------------------------------------
CREATE TABLE `employee` (
  `employee_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone_no` VARCHAR(20) NOT NULL,
  `store_id` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`employee_id`),
  INDEX `idx_fk_store_id` (`store_id` ASC),
  CONSTRAINT `fk_Employee_store`
    FOREIGN KEY (`store_id`)
    REFERENCES `store` (`store_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
;



-- -----------------------------------------------------
-- Table `liquor_store_draft`.`category`
-- -----------------------------------------------------
CREATE TABLE `category` (
  `category_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`category_id`))
;



-- -----------------------------------------------------
-- Table `liquor_store_draft`.`liquor`
-- -----------------------------------------------------
CREATE TABLE `liquor` (
  `liquor_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `barcode_id` VARCHAR(50) NOT NULL ,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `country_of_origin` VARCHAR(100) NOT NULL,
  `proof` INT NOT NULL DEFAULT 80,
  `volume_in_liter` DECIMAL(3,2) UNSIGNED NULL DEFAULT 0.75,
  `price` DECIMAL(5,2) NOT NULL,
  `stock_cost` DECIMAL(5,2) NOT NULL,
  INDEX `idx_title` (`name` ASC),
  PRIMARY KEY (`liquor_id`))
;

--
--
CREATE UNIQUE  INDEX liquor_barcode_id

    ON `liquor` (barcode_id); 
--
--
-- -----------------------------------------------------
-- Table `liquor_store_draft`.`item`
-- ----------------------------------------------------
CREATE TABLE `item` (
  `item_id` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `liquor_id` TINYINT UNSIGNED, 
  `vintage` VARCHAR (20),
  PRIMARY KEY (`item_id`),
  INDEX `idx_fk_Liquor_id` (`liquor_id` ASC),
  CONSTRAINT `fk_liquor`
    FOREIGN KEY (`liquor_id`)
    REFERENCES `liquor` (`liquor_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
;


-- -----------------------------------------------------
-- Table `liquor_store_draft`.`purchase`
-- -----------------------------------------------------
CREATE TABLE `purchase` (
  `purchase_id` INT NOT NULL AUTO_INCREMENT,
  `purchase_date` DATE NOT NULL,
  `purchase_total_amt` DECIMAL(7,2) NOT NULL,
  `main_payment_type` VARCHAR(30) NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`purchase_id`),
  UNIQUE INDEX `idx_purchase` (`purchase_date` ASC, `customer_id` ASC),
  INDEX `idx_fk_customer_id` (`customer_id` ASC),
  CONSTRAINT `customer_purchase`
    FOREIGN KEY (`customer_id`)
    REFERENCES `liquor_store_draft`.`customer` (`customer_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
  
  )
;



-- -----------------------------------------------------
-- Table `liquor_store_draft`.`purchase_item`
-- -----------------------------------------------------
CREATE TABLE `purchase_item` (
    `purchase_id` INT NOT NULL,
  `item_id` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`purchase_id`, `item_id`),
  INDEX `fk_purchase_has_item_idx` (`item_id` ASC),
  INDEX `fk_item_has_purchase_idx` (`purchase_id` ASC),
  CONSTRAINT `fk_purchase_has_item`
    FOREIGN KEY (`purchase_id`)
    REFERENCES `purchase` (`purchase_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_item_has_purchase`
    FOREIGN KEY (`item_id`)
    REFERENCES `item` (`item_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

-- -----------------------------------------------------
-- Table `liquor_store_draft`.`liquor_category`
-- -----------------------------------------------------
CREATE TABLE `liquor_category` (
  `category_id` TINYINT UNSIGNED NOT NULL,
  `liquor_id` TINYINT UNSIGNED NOT NULL,
   PRIMARY KEY (`category_id`,`liquor_id` ),
  INDEX `fk_Liquoridx` (`category_id` ASC),
  INDEX `fk_category_Liquor_idx` (`liquor_id` ASC),
  CONSTRAINT `fk_category_liquor`
    FOREIGN KEY (`liquor_id`)
    REFERENCES `liquor` (`liquor_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_liquor_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `category` (`category_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    )
;



