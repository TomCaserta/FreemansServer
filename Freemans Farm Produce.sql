SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `freemans` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `freemans` ;

-- -----------------------------------------------------
-- Table `freemans`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`customers` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `customerName` VARCHAR(45) NULL,
  `invoiceEmail` VARCHAR(45) NULL,
  `confirmationEmail` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`suppliers` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `supplierName` VARCHAR(45) NULL,
  `terms` INT NULL,
  `remittanceEmail` VARCHAR(45) NULL,
  `confirmationEmail` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`products` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `productName` VARCHAR(45) NULL,
  `validWeights` BLOB NULL,
  `quickbooksItem` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`packaging`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`packaging` (
  `ID` INT NOT NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`test` 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`test` (
	`ID` INT NOT NULL,
	`test` VARCHAR(100) NOT NULL,
	`data` BLOB NOT NULL,
	`entities` BLOB NULL,
	`environment` VARCHAR(100) NULL, 
	`time` BIGINT NOT NULL,
	`date` BIGINT NOT NULL,
	`semantics`  VARCHAR(200) NULL,
	`losslesscapture` BOOLEAN FALSE,
	PRIMARY KEY (`ID`))
	ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `freemans`.`productWeights`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`productWeights` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`hauliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`hauliers` (
  `ID` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `remittanceEmail` VARCHAR(45) NULL,
  PRIMARY KEY (`ID`))haulierscustomers
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`users` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NULL,
  `password` VARCHAR(64) NULL,
  `permissions` BLOB NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`produce`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`produce` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `productID` INT NULL,
  `supplierID` INT NULL,
  `haulageID` INT NULL,
  `groupID` INT NULL,
  `cost` FLOAT NULL,
  `weightID` INT NULL,
  `packagingID` INT NULL,
  `timeofpurchase` DATETIME NULL,
  `insertedBy` INT NULL,
  PRIMARY KEY (`ID`),
  INDEX `supplierID_idx` (`supplierID` ASC),
  INDEX `productID_idx` (`productID` ASC),
  INDEX `packagingID_idx` (`packagingID` ASC),
  INDEX `weightID_idx` (`weightID` ASC),
  INDEX `groupID_idx` (`groupID` ASC),
  INDEX `userID_idx` (`insertedBy` ASC),
  INDEX `haulageID_idx` (`haulageID` ASC),
  CONSTRAINT `supplierID`
    FOREIGN KEY (`supplierID`)
    REFERENCES `freemans`.`suppliers` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `productID`
    FOREIGN KEY (`productID`)
    REFERENCES `freemans`.`products` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `packagingID`
    FOREIGN KEY (`packagingID`)
    REFERENCES `freemans`.`packaging` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `weightID`
    FOREIGN KEY (`weightID`)
    REFERENCES `freemans`.`productWeights` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `groupID`
    FOREIGN KEY (`groupID`)
    REFERENCES `freemans`.`produce` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `haulageID`
    FOREIGN KEY (`haulageID`)
    REFERENCES `freemans`.`hauliers` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `userID`
    FOREIGN KEY (`insertedBy`)
    REFERENCES `freemans`.`users` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `freemans`.`sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `freemans`.`sales` (
  `ID` INT NOT NULL AUTO_INCREMENT,
  `customerID` INT NULL,
  `produceID` INT NULL,
  `amount` INT NULL,
  `haulageID` INT NULL,
  `deliveryCost` FLOAT NULL,
  `cost` FLOAT NULL,
  `deliveryDate` DATETIME NULL,
  PRIMARY KEY (`ID`),
  INDEX `customerID_idx` (`customerID` ASC),
  INDEX `produceID_idx` (`produceID` ASC),
  CONSTRAINT `customerID`
    FOREIGN KEY (`customerID`)
    REFERENCES `freemans`.`customers` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `produceID`
    FOREIGN KEY (`produceID`)
    REFERENCES `freemans`.`produce` (`ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
