CREATE DATABASE  IF NOT EXISTS `freemans` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `freemans`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: freemans
-- ------------------------------------------------------
-- Server version	5.6.14-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `company_options`
--

DROP TABLE IF EXISTS `company_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_options` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `data` blob,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_options`
--

LOCK TABLES `company_options` WRITE;
/*!40000 ALTER TABLE `company_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `company_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customers` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `customerName` varchar(45) DEFAULT NULL,
  `invoiceEmail` varchar(45) DEFAULT NULL,
  `confirmationEmail` varchar(45) DEFAULT NULL,
  `quickbooksName` varchar(45) DEFAULT NULL,
  `billto1` varchar(100) DEFAULT NULL,
  `billto2` varchar(100) DEFAULT NULL,
  `billto3` varchar(100) DEFAULT NULL,
  `billto4` varchar(100) DEFAULT NULL,
  `billto5` varchar(100) DEFAULT NULL,
  `shipto1` varchar(100) DEFAULT NULL,
  `shipto2` varchar(100) DEFAULT NULL,
  `shipto3` varchar(100) DEFAULT NULL,
  `shipto4` varchar(100) DEFAULT NULL,
  `shipto5` varchar(100) DEFAULT NULL,
  `terms` int(10) DEFAULT NULL,
  `faxNumber` varchar(45) DEFAULT NULL,
  `phoneNumber` varchar(45) DEFAULT NULL,
  `isEmailedConfirmation` tinyint(1) DEFAULT NULL,
  `isEmailedInvoice` tinyint(1) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `timeCreated` bigint(13) DEFAULT NULL,
  `timeModified` bigint(13) DEFAULT NULL,
  `termsRef` varchar(45) DEFAULT NULL,
  `locationID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (107,'A 1 VEG (SPITS) LTD','a1vegltd@yahoo.co.uk','a1vegltd@yahoo.co.uk','60000-1184736668','A 1 VEG (SPITALFIELDS) LTD','P20-22 Western International Market','Hayes Road','Middx','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(108,'A 1 Veg (BIRM) LTD','a1vegltd@yahoo.co.uk','a1vegltd@yahoo.co.uk','80000203-1243574695','A1 Veg (BIRMINGHAM)','P20-22','Western International Market','Hayes Road','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(109,'A 1 VEG','a1vegltd@yahoo.co.uk','a1vegltd@yahoo.co.uk','50000-1184736668','A1 Veg Limited','P20-22','Western International Market','SOUTHALL','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,'02088 481083','02088 480700',1,1,1,NULL,NULL,NULL,NULL),(110,'A 1 VEG (MANC) LTD','a1vegltd@yahoo.co.uk','a1vegltd@yahoo.co.uk','80000209-1245388561','A1 VEG (MANC)','P20-22','Western International Market','SOUTHALL','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(111,'A & R PRODUCE LTD','info@aandrproduce.co.uk','info@aandrproduce.co.uk','8000027C-1372929723','A & R Produce Ltd','1 Queens Yard','Whitepost Lane','LONDON','E9 5EN',NULL,NULL,NULL,NULL,NULL,0,'02089 867178','02089 858017',1,1,1,NULL,NULL,NULL,NULL),(112,'A C PRODUCE','salesadmin@acproduceimports.co.uk','salesadmin@acproduceimports.co.uk','80000-1184736668','A C Produce Imports Ltd','Arch 23 - 24, Fruit & Vegetable Market','New Covent Garden Market','London','SW8 5PA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(113,'A.W BAXTER (TRANSPORT)','diane@baxtertransport.co.uk','diane@baxtertransport.co.uk','1B70000-1190955469','A.W BAXTER (TRANSPORT)',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01704 232233','01704 211211',1,1,1,NULL,NULL,NULL,NULL),(114,'ALMOND G','gary@galmond.co.uk','gary@galmond.co.uk','B0000-1184736668','G Almond','Unit 16 - 26 Block A','Wholesale Fruit & Vegetable Market','LIVERPOOL','L13 2EP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01512 209883',1,1,1,NULL,NULL,NULL,NULL),(115,'ASHER','accounts@davinfoods.com','accounts@davinfoods.com','E0000-1184736668','Asher & Son (Fruit & Veg Supplies) Ltd','Savvas House','Renwick Road','ESSEX','IG11 OSH',NULL,NULL,NULL,NULL,NULL,0,'02085 931315','07973 907939',1,1,1,NULL,NULL,'80000-1196400885',NULL),(116,'A & M','jay@gradegoldcatering.co.uk','jay@gradegoldcatering.co.uk','1B90000-1195197246','A & M Fruits & Veg','357 Uxbridge Road','Southall','MIDDLESEX','UB1 3EJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(117,'B.D.B MARKETING Ltd.','bradleybrown.bdb@hotmail.com','bradleybrown.bdb@hotmail.com','140000-1184736668','B.D.B MARKETING Ltd.','62-29 LINK HOUSE, FRUIT & VEG MARKET','NEW COVENT GARDEN','VAUXHALL','SW8 5LL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(118,'BARTLETTS','john@rrwbartlett.co.uk','john@rrwbartlett.co.uk','8000027E-1373521769','R.&R.W. Bartlett Ltd. (PH)','Shenstone Park','Little Hay','Staffs',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(119,'BENTLEY','ian@davyfresh.net','ian@davyfresh.net','1B0000-1184736668','C Bentley & Sons','Stand No 10-11','Wholesale Market','WOLVERHAMPTON',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(120,'BETTINSON (CUST)','phil.bettinson.ltd@gmail.com','phil.bettinson.ltd@gmail.com','8000026B-1352185942','Phil Bettinson Ltd','2 The Heights','Strawberry fields','Southampton','SO30 4QY',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(121,'BEVANS','lewis_bevan@hotmail.com','lewis_bevan@hotmail.com','1D0000-1184736669','S J Bevan','Wholesale Fruit Centre','6 Bessemer Road','Cardiff','CF11 8BE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(122,'BOSTON PRODUCE,,','Keith.Crossingham@BostonProduce.co.uk','Keith.Crossingham@BostonProduce.co.uk','8000022B-1287126761','Boston Produce Ltd','Station Road','Swineshead','LINCS','PE20 3PN',NULL,NULL,NULL,NULL,NULL,NULL,'01205311091','01205311377',1,1,1,NULL,NULL,NULL,NULL),(123,'C & A PRODUCE',NULL,NULL,'2D0000-1184736669','C & A Produce Ltd','21 The Arches, Fruit & Vegetable Market','New Covent Garden Market','London','SW8 5SN',NULL,NULL,NULL,NULL,NULL,NULL,'0207 498867','0207 7200264',1,1,1,NULL,NULL,NULL,NULL),(124,'CHAMBERS',NULL,NULL,'2F0000-1184736669','Chambers Ltd','W11-12','Western International Market','SOUTHALL','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02085 613257',1,1,1,NULL,NULL,NULL,NULL),(125,'CHEFS CHOICE LTD','info@chefschoiceuk.com','info@chefschoiceuk.com','80000210-1254821786','Chefs Choice (N.C.G) Ltd t/a Chefs Choice','Arch 6','Fruit & Veg Market','London','SW8 5PP',NULL,NULL,NULL,NULL,NULL,NULL,'0207 720546',NULL,1,1,1,NULL,NULL,NULL,NULL),(126,'DAVENPORT',NULL,NULL,'1AF0000-1187935698','DAVENPORT TRANSPORT LTD','TOLLGATE CRESENT','BURSCOUGH','ORMSKIRK','L40 8LT',NULL,NULL,NULL,NULL,NULL,NULL,'01704 893409','01704 893106',1,1,1,NULL,NULL,NULL,NULL),(127,'DIXONS','helen@andrew-dixon.co.uk','helen@andrew-dixon.co.uk','D10000-1185180312','East Shropshire Produce Ltd','Suite 309, Grosvenor House','Central Park','Shropshire','TF2 9TW',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(128,'DUNN','dunnsproduce@yahoo.co.uk','dunnsproduce@yahoo.co.uk','D40000-1185180312','Dunns Produce Ltd','84 Wholesale Market Precinct','Pershore Street','BIRMINGHAM','B5 6UN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(129,'ESTHER MACKS',NULL,NULL,'80000268-1349958875','Esther Macks Produce Ltd','B34-B35 New Smithfield Market','Whitworth Street','Manchester','M11 2WJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(130,'FIELD SUPPLIES','richard.hollingworth@fieldsupplies.co.uk','richard.hollingworth@fieldsupplies.co.uk','8000025D-1340345265','Field Supplies','Field View','Willington Road','Etwall','DE65 6NR',NULL,NULL,NULL,NULL,NULL,NULL,'01283 734833','01283 734666',1,1,1,NULL,NULL,NULL,NULL),(131,'FIJI',NULL,NULL,'D80000-1185180312','Fiji Fruit & Vegables London Ltd','12 And 13 Arches','Fruit & Vegetable Market','LONDON S.W.8.',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02076 227648','02074 980803',1,1,1,NULL,NULL,NULL,NULL),(132,'FRESH CUT','peter@freshcutfruitandveg.co.uk','peter@freshcutfruitandveg.co.uk','E30000-1185180312','Fresh-Cut Fruit & Veg Ltd','Howard Chase','Basildon','ESSEX','SS14 3BE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(133,'FRESH FARM CATERING','accts@freshfarmcatering.com','accts@freshfarmcatering.com','E50000-1185180312','Fresh Farm Catering','Unit 2','Hamlet Industrial Centre','LONDON','E9 5EN',NULL,NULL,NULL,NULL,NULL,NULL,'02085 256729','02085 250809',1,1,1,NULL,NULL,NULL,NULL),(134,'FRESH PREP LTD','barry.spencer@freshprep.co.uk','barry.spencer@freshprep.co.uk','1170000-1185180313','Fresh Prep (UK) Ltd','Charbridge Way','Bicester Dist Park','Bicester','OX26 4SX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01869 325655',1,1,1,NULL,NULL,NULL,NULL),(135,'FRUITY','accounts@fruityfresh.com','accounts@fruityfresh.com','E90000-1185180312','Fruity Fresh (Western) Limited','P46-48','Western International Market','SOUTHALL','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02085 618196',1,1,1,NULL,NULL,NULL,NULL),(136,'GASKELL',NULL,NULL,'F20000-1185180313','J.W.Gaskell Ltd','Stand 121-123  Block D','Wholesale Market','LIVERPOOL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01512 208984',1,1,1,NULL,NULL,NULL,NULL),(137,'GRADE GOLD','jay@gradegoldcatering.co.uk','jay@gradegoldcatering.co.uk','F60000-1185180313','GradeGold Catering Ltd','357 Uxbridge Road','Southall','MIDDLESEX','UB1 3EJ',NULL,NULL,NULL,NULL,NULL,NULL,'02088935584',NULL,1,1,1,NULL,NULL,NULL,NULL),(138,'GRIFFITHS TRANSPORT','mandy@mjgriffithstransport.co.uk','mandy@mjgriffithstransport.co.uk','8000022D-1291625201','GRIFFITHS TRANSPORT','Tollgate Crescent,','Burscough Industrial Estate,','Lancs','L40 8LT',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(139,'GT Produce Ltd','jean.riley@gtproduce.co.uk','jean.riley@gtproduce.co.uk','1760000-1185180314','GT Produce Ltd','Yorkshire Produce Centre','Pontefract Lane','LS9 OPX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Gene - 01132 019808','01132 019841',1,1,1,NULL,NULL,NULL,NULL),(140,'H.N. CATERING',NULL,NULL,'80000200-1241759452','H.N. CATERING','WHOLESALE FRUIT CENTRE','BESSEMER ROAD','CARDIFF',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(141,'HM Customs & Excise - Receivable',NULL,NULL,'800001CA-1210584755',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(142,'IBERVEG C','info@iberveg.com','info@iberveg.com','80000279-1370841393','IBERVEG UK LTD','66-69 Link House','Fruit & Vegetable Market','Vauxhall','SW8 5PA',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'07956 074778',1,1,1,NULL,NULL,NULL,NULL),(143,'J NEAL',NULL,NULL,'8000022F-1292575848','JOHN NEAL FARMS (BENINGTON) LIMITED','The Grange','Benington','LINCS','PE22 0DR',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01205 760209',1,1,1,NULL,NULL,NULL,NULL),(144,'J.T.S HILLS','genna@jtshill.co.uk','genna@jtshill.co.uk','1B60000-1190358561','J.T.S. Hills & Sons','P40 - P42 Western International Market','Hayes Road','Southall Middx','UB2 5XF',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0208 8481566',1,1,1,NULL,NULL,NULL,NULL),(145,'KNIGHT',NULL,NULL,'11D0000-1185180313','Knight & Rawlings Ltd','Unit 57','Western International Market','Hayes Road Southall','UB2 5XJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02088 484621',1,1,1,NULL,NULL,NULL,NULL),(146,'LEY','kevin@fredleyandsons.com','kevin@fredleyandsons.com','1210000-1185180313','F. Ley & Sons Ltd','Wholesale Fruit Market','11-15 Ebenezer Street','W Glam','SA1 5BJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(147,'M H MALIK','malikveg@hotmail.co.uk','malikveg@hotmail.co.uk','800001DB-1217490723','M H Malik Produce','Stand 53','New Spits Market','E10 5Q',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(148,'MAN FOODS','manfoods@btconnect.com','manfoods@btconnect.com','800001FC-1238481718','Man Foods','3 Dorma Trading Est','Staffa Road','Leyton','E10 7QX',NULL,NULL,NULL,NULL,NULL,NULL,'02085 396138','02085 582078',1,1,1,NULL,NULL,NULL,NULL),(149,'MARTINS PRODUCE',NULL,NULL,'12D0000-1185180313','MARTINS PRODUCE','NORWOOD YARD','FISHTOFT ,','LINCS PE21 ORN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01205 367909','01205 354826',1,1,1,NULL,NULL,NULL,NULL),(150,'MEALMAKER','ian@mealmaker.co.uk','ian@mealmaker.co.uk','1300000-1185180313','Meal Maker  London Ltd.','Units 7-9, Sleaford Industrial Estate','Sleaford Street','S W 8 5AB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02074 982269','02079 782669',1,1,1,NULL,NULL,NULL,NULL),(151,'MILLER JACKSON',NULL,NULL,'1320000-1185180313','Miller And Jackson Limited','New Wholesale Market','Checkers Road','DERBY','DE2 6WT',NULL,NULL,NULL,NULL,NULL,NULL,'01332 368787','01332 340954',1,1,1,NULL,NULL,NULL,NULL),(152,'National Westminster Bank',NULL,NULL,'1C10000-1201091691','National Westminster Bank',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(153,'NELLIST','nellist@cane4.karoo.co.uk','nellist@cane4.karoo.co.uk','1350000-1185180313','Nellist & Company Ltd','Unit 8 Fruit Market','Henry Boot Way','Hull','HU4 7EA',NULL,NULL,NULL,NULL,NULL,NULL,'01482 213425','01482 325295',1,1,1,NULL,NULL,NULL,NULL),(154,'PALIN','fran.watts@john-palin.co.uk','fran.watts@john-palin.co.uk','13F0000-1185180313','J.Palin Wholesale','Brookfield Industrial Estate','Old Coach Road','MATLOCK Derby',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01629 760246',NULL,1,1,1,NULL,NULL,NULL,NULL),(155,'PEARSON','accounts@epearsontransport.co.uk','accounts@epearsontransport.co.uk','1420000-1185180313','W.E. & C.P. Pearson','9-11, Freiston Enterprise Park','Priory Road, Freiston,','LINCS PE22 OJZ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(156,'PENNINGTON',NULL,NULL,'1430000-1185180313','A & N PENNINGTON (Manchester) Ltd.','Stalls D28-29','New Smithfield Market','Manchester','M11 2WJ',NULL,NULL,NULL,NULL,NULL,NULL,'01612 230740','01612 238134',1,1,1,NULL,NULL,NULL,NULL),(157,'Peter Hatton Ltd','hatton.peter7@gmail.com','hatton.peter7@gmail.com','8000026D-1354009943','Peter Hatton Ltd','Manchester Business Park','3000 Aviator Way','Manchester','M22 5TG',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01612661181',1,1,1,NULL,NULL,NULL,NULL),(158,'QUALITY PREPARED',NULL,NULL,'80000295-1388474720','Quality Prepared','Arch 6','Fruit & Veg Market','London','SW8 5PP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(159,'R & A (CASTLEFORD)',NULL,NULL,'14B0000-1185180313','R & A Stores Ltd','Methley Road','Castleford','WF10 INX',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01977 555811','01977 556688',1,1,1,NULL,NULL,NULL,NULL),(160,'SALAD CHOICE','saladchoiceltd@yahoo.com','saladchoiceltd@yahoo.com','15B0000-1185180314','Salad Choice Ltd','12-13 Claremont Way Ind Est','Claremont Way','London','NW2 1BG',NULL,NULL,NULL,NULL,NULL,NULL,'02084 583554','02084 583555',1,1,1,NULL,NULL,NULL,NULL),(161,'SALAD CHOICE UK LTD','saladchoiceltd@yahoo.com','saladchoiceltd@yahoo.com','8000023B-1307691458','Salad Choice (UK) Ltd','12-13 Claremont Way Ind Est','Claremont Way','London','NW2 1BG',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(162,'SHERINGHAM CATERING LTD',NULL,NULL,'8000023F-1319186493','SHERINGHAM CATERING LTD','A165-169 FRUIT & VEG MARKET','NEW COVENT GARDEN MARKET','VAUXHALL','SW8 5EE',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(163,'SHIPLEY','shipleys@tiscali.co.uk','shipleys@tiscali.co.uk','1610000-1185180314','Shipleys FoodService Ltd','Upton Court Farm','Upton Court  Road','Berks','SL3 7LU',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01753531520/525155',1,1,1,NULL,NULL,NULL,NULL),(164,'SPOONER',NULL,NULL,'16B0000-1185180314','M E Spooner T/A D Spooner & Sons (Potatoe','4 Lane End Nursery','High Street','Market Drayton','TF9 2RS',NULL,NULL,NULL,NULL,NULL,NULL,'01630661394','01216225356',1,1,1,NULL,NULL,NULL,NULL),(165,'T C K','julie@tckproduce.com','julie@tckproduce.com','1700000-1185180314','TCK Fresh Produce Ltd','TCK House','Caxton Trading Estate','HAYES MIDDX','UB3 1BE',NULL,NULL,NULL,NULL,NULL,NULL,'0208 490 5430','0208 490 5420',1,1,1,NULL,NULL,NULL,NULL),(166,'T G FRUIT','accounts@tgfruit.co.uk','accounts@tgfruit.co.uk','1710000-1185180314','T. G. Fruits Ltd','Crowhurst Corner','Crowhurst Road','BRIGHTON','BN1 8AP',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01273503390',1,1,1,NULL,NULL,NULL,NULL),(167,'T.P.D. SHEFFIELD','t-dobson@btconnect.com','t-dobson@btconnect.com','1730000-1185180314','T.P.D. Fresh Produce Ltd','Unit 3A  South Yorkshire Fresh Produce','and Flower Centre','SHEFFIELD','S9 4WN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01142441820',1,1,1,NULL,NULL,NULL,NULL),(168,'TONY TOACH & SON','tony@toach.com','tony@toach.com','8000023D-1309508485','TONY TOACH & SON','UNITS 18/19','LEICESTER WHOLESALE MARKET','LEICESTER','LE2 7SN',NULL,NULL,NULL,NULL,NULL,NULL,'01162859110','01162552775',1,1,1,NULL,NULL,NULL,NULL),(169,'TOTAL (A F I)',NULL,NULL,'14F0000-1185180313','Total Produce & Flowers Ltd','T/A AFI','Stands 1-7, Hall 1,','Hayes Rd','UB2 5XN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02088484644',1,1,1,NULL,NULL,NULL,NULL),(170,'TOTAL PRODUCE (CARD)','tpmaccounts@totalproduce.com','tpmaccounts@totalproduce.com','17C0000-1185180314','Total Produce Ltd','Wholesale Market','Bessemer Road','Cardiff',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(171,'TOTAL PRODUCE (LIVERPOOL)','jfoster@totalproduce.com','jfoster@totalproduce.com','17D0000-1185180314','Total Produce (Liverpool)','Stand 112 Block D','Wholesale Market','Liverpool','L13 2EJ',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'01512595855',1,1,1,NULL,NULL,NULL,NULL),(172,'TOTAL PRODUCE (MANC)','tpmaccounts@totalproduce.com','tpmaccounts@totalproduce.com','240000-1184736669','TOTAL PRODUCE (Manchester) LTD','Stand D30-33','New Smithfield Market','WHITWORTH STREET EAST Mancheste','M11 2WW',NULL,NULL,NULL,NULL,NULL,NULL,'01612232845','01612239478',1,1,1,NULL,NULL,NULL,NULL),(173,'TOTAL PRODUCE (NOTTINGHAM)','tpmaccounts@totalproduce.com','tpmaccounts@totalproduce.com','800001F3-1233302177','Total Produce Nottingham Ltd','Unit 16-20','Wholsale Fruit & Flower Market','Clarke Road Nottingham','NG2 3JJ',NULL,NULL,NULL,NULL,NULL,NULL,'0115 9866213','0115 9867040',1,1,1,NULL,NULL,NULL,NULL),(174,'Total Produce (Sheffield)','tpmaccounts@totalproduce.com','tpmaccounts@totalproduce.com','800001CE-1212656701','Total Produce Ltd','Unit 3B/4B','Sheffield Parkway Food & Flower Centre','Parkway Drive Sheffield','S9 4WN',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,1,1,NULL,NULL,NULL,NULL),(175,'TROPICAL','tropical786@btconnect.com','tropical786@btconnect.com','1800000-1185180314','Tropical Catering Ltd','B32-B33','New Covent Garden Market','LONDON','SW8 5LL',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'02079782600',1,1,1,NULL,NULL,NULL,NULL),(176,'WATTS FARMS','accountspayable@wattsfarms.co.uk','accountspayable@wattsfarms.co.uk','80000236-1300962309','Watts Farms Accounts','Sondix House, Unit B Sandpit Road','Dartford','Kent','DA1 5BU',NULL,NULL,NULL,NULL,NULL,NULL,'01322620980','01689877175',1,1,1,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `locationName` varchar(100) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (3,'Birmingham',1),(4,'Doncaster',1),(5,'Leeds',1),(6,'Bradford',1),(7,'Leicester',1),(8,'London',1),(9,'Nottingham',1),(10,'Sheffield',1),(11,'Barking',1),(12,'Barnsley',1),(13,'Biggleswade',1),(14,'Booker',1),(15,'Castleford',1),(16,'Coventry',1),(17,'Huddersfield',1),(18,'Manchester',1),(19,'Wakefield',1),(20,'Wolverhampton',1),(21,'Bicester',1),(22,'Bolton',1),(23,'Brighton',1),(24,'Bristol',1),(25,'Cardiff',1),(26,'Evesham',1),(27,'Gateshead',1),(28,'Gloucester',1),(29,'Ipswich',1),(30,'Lincoln',1),(31,'Liverpool',1),(32,'Matlock',1),(33,'Middlesborough',1),(34,'Norwich',1),(35,'Pershore',1),(36,'Southampton',1),(37,'Stoke',1),(38,'Accrington',1),(39,'Knowsley',1),(40,'Ormskirk',1),(41,'Preston',1),(42,'Ripon',1),(43,'Wigan',1),(44,'Carlisle',1),(45,'Edinburgh',1),(46,'Glasgow',1),(47,'Lancaster',1);
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data` varchar(45) DEFAULT NULL,
  `invokedBy` int(11) DEFAULT NULL,
  `time` bigint(13) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packaging`
--

DROP TABLE IF EXISTS `packaging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packaging` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packaging`
--

LOCK TABLES `packaging` WRITE;
/*!40000 ALTER TABLE `packaging` DISABLE KEYS */;
INSERT INTO `packaging` VALUES (1,'BOX',1),(2,'NET',1),(3,'BIN',1),(4,'P/P',1),(5,'F/T',1),(6,'F/P',1),(7,'D/D',1),(8,'BAG',1),(9,'BULK',1);
/*!40000 ALTER TABLE `packaging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produce`
--

DROP TABLE IF EXISTS `produce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produce` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `productID` int(11) DEFAULT NULL,
  `supplierID` int(11) DEFAULT NULL,
  `haulageID` int(11) DEFAULT NULL,
  `groupID` int(11) DEFAULT NULL,
  `cost` decimal(16,8) DEFAULT NULL,
  `weightID` int(11) DEFAULT NULL,
  `packagingID` int(11) DEFAULT NULL,
  `descriptorID` int(11) DEFAULT NULL,
  `timeofpurchase` bigint(13) DEFAULT NULL,
  `insertedBy` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `amount` decimal(16,8) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `supplierID_idx` (`supplierID`),
  KEY `productID_idx` (`productID`),
  KEY `packagingID_idx` (`packagingID`),
  KEY `weightID_idx` (`weightID`),
  KEY `userID_idx` (`insertedBy`),
  KEY `haulageID_idx` (`haulageID`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produce`
--

LOCK TABLES `produce` WRITE;
/*!40000 ALTER TABLE `produce` DISABLE KEYS */;
INSERT INTO `produce` VALUES (50,9,5,1,60,500.00000000,1,0,0,1394700851060,NULL,1,500.00000000),(51,9,5,1,61,40.50000000,7,0,0,1394701360752,NULL,1,100.00000000),(52,71,132,1,62,2.20000000,14,0,2,1394323200000,NULL,1,88.00000000),(53,9,5,1,63,44.00000000,1,0,1,1394785087705,NULL,1,44.00000000);
/*!40000 ALTER TABLE `produce` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productcategories`
--

DROP TABLE IF EXISTS `productcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productcategories` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(64) DEFAULT NULL,
  `categoryColour` varchar(45) NOT NULL DEFAULT '#FFFFFF',
  `active` int(1) DEFAULT '1',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productcategories`
--

LOCK TABLES `productcategories` WRITE;
/*!40000 ALTER TABLE `productcategories` DISABLE KEYS */;
INSERT INTO `productcategories` VALUES (12,'CAULI','#ffffff',1),(13,'CALABRESE','#448020',1),(14,'LEEKS','#b0f4b3',1),(15,'CABBAGE','#c9fccb',1),(16,'RED & WHITE CABBAGE','#ff6f6f',1),(17,'POTATOES','#0160fe',1),(18,'SWEET POTS','#ff1c21',1),(19,'RED ONIONS','#981ab3',1),(20,'ONIONS','#9c6543',1),(21,'PARSNIPS','#fdffd2',1),(22,'CARROT','#fca41f',1),(23,'SWEDES','#79be58',1);
/*!40000 ALTER TABLE `productcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productdescriptors`
--

DROP TABLE IF EXISTS `productdescriptors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productdescriptors` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(64) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productdescriptors`
--

LOCK TABLES `productdescriptors` WRITE;
/*!40000 ALTER TABLE `productdescriptors` DISABLE KEYS */;
INSERT INTO `productdescriptors` VALUES (1,'X/L',1),(2,'MED',1),(3,'I/P',1),(4,'MIXED',1),(5,'65MM+',1),(6,'25-45MM',1),(7,'40\'S',1),(8,'50\'S',1),(9,'40/60 GRAMS',1),(10,'L1',1),(11,'L2',1),(12,'L1/L2',1),(13,'M/XL',1),(14,'LONG LIFE',1),(15,'B SIZE',1),(16,'60/80',1),(17,'70/100',1),(18,'NO1\'S',1),(19,'NO2\'S',1),(20,'X/LARGE',1),(21,'POLY BAG',1);
/*!40000 ALTER TABLE `productdescriptors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productgroups`
--

DROP TABLE IF EXISTS `productgroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productgroups` (
  `productID` int(11) DEFAULT NULL,
  `packagingID` int(11) DEFAULT NULL,
  `weightID` int(11) DEFAULT NULL,
  `descriptorID` int(11) DEFAULT NULL,
  `lastUsed` int(24) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productgroups`
--

LOCK TABLES `productgroups` WRITE;
/*!40000 ALTER TABLE `productgroups` DISABLE KEYS */;
INSERT INTO `productgroups` VALUES (2,3,3,NULL,NULL,1,1),(2,2,4,NULL,NULL,1,2),(3,2,2,NULL,NULL,1,3),(3,2,2,NULL,NULL,1,4),(3,2,5,NULL,NULL,1,5),(3,1,2,NULL,NULL,1,6),(3,3,2,NULL,NULL,1,7),(3,2,3,NULL,NULL,1,8),(5,2,6,NULL,NULL,1,9),(5,2,5,NULL,NULL,1,10),(7,3,5,NULL,NULL,1,11),(2,1,1,NULL,NULL,1,12),(3,2,2,NULL,NULL,1,13),(3,0,0,NULL,NULL,1,14),(4,2,4,NULL,NULL,1,15),(2,0,0,NULL,NULL,1,16),(2,0,0,NULL,NULL,1,17),(5,3,2,NULL,NULL,1,18),(1,0,0,NULL,NULL,1,19),(3,0,2,NULL,NULL,1,20),(1,0,0,NULL,NULL,1,21),(2,0,0,NULL,NULL,1,22),(3,1,2,NULL,NULL,1,23),(1,0,0,NULL,NULL,1,24),(3,0,0,NULL,NULL,1,25),(1,3,0,NULL,NULL,1,26),(1,0,0,NULL,NULL,1,27),(2,0,0,NULL,NULL,1,28),(1,0,0,NULL,NULL,1,29),(2,0,0,NULL,NULL,1,30),(1,0,0,NULL,NULL,1,31),(3,1,2,NULL,NULL,1,32),(3,1,5,NULL,NULL,1,33),(71,2,14,NULL,NULL,1,34),(96,1,1,NULL,NULL,1,35),(69,2,4,NULL,NULL,1,36),(63,7,15,NULL,NULL,1,37),(81,2,7,NULL,NULL,1,38),(57,2,7,NULL,NULL,1,39),(52,8,8,NULL,NULL,1,40),(43,1,7,NULL,NULL,1,41),(72,1,9,NULL,NULL,1,42),(6,3,18,NULL,NULL,1,43),(47,2,12,NULL,NULL,1,44),(48,2,12,NULL,NULL,1,45),(50,1,5,NULL,NULL,1,46),(50,2,7,NULL,NULL,1,47),(65,0,12,NULL,NULL,1,48),(50,9,11,NULL,NULL,1,49),(9,9,11,NULL,NULL,1,50),(9,9,11,NULL,NULL,1,51),(9,2,7,NULL,NULL,1,52),(95,9,11,NULL,NULL,1,53),(9,8,14,NULL,NULL,1,54),(71,9,11,NULL,NULL,1,55),(71,2,14,NULL,NULL,1,56),(10,5,17,NULL,NULL,1,57),(96,1,1,NULL,NULL,1,58),(96,1,1,NULL,NULL,1,59),(9,0,1,0,NULL,1,60),(9,0,7,0,NULL,1,61),(71,0,14,2,NULL,1,62),(9,0,1,1,NULL,1,63);
/*!40000 ALTER TABLE `productgroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `productName` varchar(45) DEFAULT NULL,
  `validWeights` blob,
  `validPackaging` blob,
  `quickbooksItem` varchar(45) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `lastModified` timestamp NULL DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `ID_idx` (`category`),
  CONSTRAINT `ID` FOREIGN KEY (`category`) REFERENCES `productcategories` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'AGRIA','','','80000094-1258096195',1,NULL,NULL),(2,'AUBERGINES','','','8000008B-1255671514',1,NULL,NULL),(3,'BAKERS','','','270000-1184736667',1,NULL,NULL),(4,'BEETROOT','','','280000-1184736667',1,NULL,NULL),(5,'BRUSSEL TOPS','','','90000-1184736667',1,NULL,NULL),(6,'BUTTERNUT SQUASH','','','80000091-1256880024',1,NULL,NULL),(7,'CALABRESE','','','C0000-1184736667',1,NULL,NULL),(8,'CARA POTS','','','2A0000-1184736667',1,NULL,NULL),(9,'CARROT','','','F0000-1184736667',1,NULL,NULL),(10,'CAULIFLOWER','','','E0000-1184736667',1,NULL,NULL),(11,'CELERIAC','','','8000009F-1320999732',1,NULL,NULL),(12,'CHARLOTTE','','','2D0000-1184736667',1,NULL,NULL),(13,'CHILEAN ONIONS NO 3\'S','','','2E0000-1184736667',1,NULL,NULL),(14,'COCKTAIL ONIONS','','','2F0000-1184736667',1,NULL,NULL),(15,'CORNISH MIDS','','','310000-1184736667',1,NULL,NULL),(16,'CORNISH NEW POTATOES','','','310000-1184736667',1,NULL,NULL),(17,'COS LETTUCE','','','80000096-1264748757',1,NULL,NULL),(18,'COURGETTES','','','320000-1184736667',1,NULL,NULL),(19,'CUCUMBER','','','8000009A-1271061205',1,NULL,NULL),(20,'CURLY KALE','','','440000-1184736667',1,NULL,NULL),(21,'CYPRUS POTS','','','330000-1184736667',1,NULL,NULL),(22,'DESIREE','','','350000-1184736667',1,NULL,NULL),(23,'DUTCH 60/80 ONIONS','','','370000-1184736667',1,NULL,NULL),(24,'DUTCH 70/100 ONIONS','','','360000-1184736667',1,NULL,NULL),(25,'DUTCH W/CABB','','','100000-1184736667',1,NULL,NULL),(26,'EGYPTIAN NICOLA','','','3C0000-1184736667',1,NULL,NULL),(27,'FRENCH CARROTS','','','3D0000-1184736667',1,NULL,NULL),(28,'GREEN CABAGE','','','3E0000-1184736667',1,NULL,NULL),(29,'GREEN PEPPERS','','','8000008E-1255671964',1,NULL,NULL),(30,'HISPI CABBAGE','','','400000-1184736667',1,NULL,NULL),(31,'ICEBERG','','','8000007D-1212731093',1,NULL,NULL),(32,'ISRAEL NICOLA','','','410000-1184736667',1,NULL,NULL),(33,'JERSEY POTATOES','','','430000-1184736667',1,NULL,NULL),(34,'JUMBO\'S','','','80000099-1265353588',1,NULL,NULL),(35,'KING EDWARD','','','450000-1184736667',1,NULL,NULL),(36,'LADY CRYSTAL','','','800000A8-1336718964',1,NULL,NULL),(37,'LEEKS','','','120000-1184736667',1,NULL,NULL),(38,'LINCOLN BARD POTS','','','8000009B-1275031469',1,NULL,NULL),(39,'LINCOLN ROCKET POTS','','','8000009B-1275031469',1,NULL,NULL),(40,'MAJORCAN POTATOES','','','460000-1184736667',1,NULL,NULL),(41,'MARIS PIPER','','','4A0000-1184736668',1,NULL,NULL),(42,'MIDS BAGS','','','480000-1184736668',1,NULL,NULL),(43,'MIDS BOXES','','','480000-1184736668',1,NULL,NULL),(44,'MOOLI','','','80000092-1256880087',1,NULL,NULL),(45,'NEW POTATOES','','','800000A9-1338447961',1,NULL,NULL),(46,'ONIONS 40/60','','','150000-1184736667',1,NULL,NULL),(47,'ONIONS 60/80','','','140000-1184736667',1,NULL,NULL),(48,'ONIONS 80/100','','','130000-1184736667',1,NULL,NULL),(49,'P S BROC','','','30000-1184736667',1,NULL,NULL),(50,'PARSNIP','','','180000-1184736667',1,NULL,NULL),(51,'PEELED ONIONS','','','800000A1-1324026214',1,NULL,NULL),(52,'PEELER GRADE','','','80000094-1258096195',1,NULL,NULL),(53,'PICKLING ONIONS','','','170000-1184736667',1,NULL,NULL),(54,'PRE-PACK POTATOES','','','800000AC-1342766308',1,NULL,NULL),(55,'PRIMO','','','500000-1184736668',1,NULL,NULL),(56,'PUMPKINS','','','190000-1184736667',1,NULL,NULL),(57,'RED CABBAGE','','','1A0000-1184736667',1,NULL,NULL),(58,'RED MIDS','','','540000-1184736668',1,NULL,NULL),(59,'RED ONIONS','','','550000-1184736668',1,NULL,NULL),(60,'RED PEPPERS','','','8000008D-1255671857',1,NULL,NULL),(61,'ROCKET 2 X 500G','','','80000086-1241179564',1,NULL,NULL),(62,'ROMANO POTATOES','','','560000-1184736668',1,NULL,NULL),(63,'SAVOY CABBAGE','','','1C0000-1184736667',1,NULL,NULL),(64,'SHALLOTS','','','80000097-1264749404',1,NULL,NULL),(65,'SPANISH ONION','','','1D0000-1184736667',1,NULL,NULL),(66,'SPINACH','','','1E0000-1184736667',1,NULL,NULL),(67,'SPRING GREEN','','','5A0000-1184736668',1,NULL,NULL),(68,'SPRING ONIONS','','','1F0000-1184736667',1,NULL,NULL),(69,'SPROUTS','','','80000-1184736667',1,NULL,NULL),(70,'SPROUTS BUTTON','','','80000-1184736667',1,NULL,NULL),(71,'SWEDES','','','210000-1184736667',1,NULL,NULL),(72,'SWEET POTATOES','','','80000095-1259913381',1,NULL,NULL),(73,'SWEETCORN','','','200000-1184736667',1,NULL,NULL),(74,'TOMATOES','','','5F0000-1184736668',1,NULL,NULL),(75,'TUNDRA','','','610000-1184736668',1,NULL,NULL),(76,'TURNIPS','','','220000-1184736667',1,NULL,NULL),(77,'VALENCIA POTATOES','','','640000-1184736668',1,NULL,NULL),(78,'WARE POTS','','','800000AC-1342766308',1,NULL,NULL),(79,'WASHED REDS','','','660000-1184736668',1,NULL,NULL),(80,'WASHED WHITES','','','80000090-1255675254',1,NULL,NULL),(81,'WHITE CABBAGE','','','230000-1184736667',1,NULL,NULL),(82,'YELLOW PEPPERS','','','8000008F-1255672007',1,NULL,NULL),(83,'MARQUIS POTS','','','800000AC-1342766308',1,NULL,NULL),(84,'LINC ACCIRD POTS','','','800000AC-1342766308',1,NULL,NULL),(85,'MARFONA POTS','','','800000AC-1342766308',1,NULL,NULL),(86,'ONIONS 70/100','','','130000-1184736667',1,NULL,NULL),(87,'MARIS BARD','','','800000AC-1342766308',1,NULL,NULL),(88,'ACCORD','','','800000AC-1342766308',1,NULL,NULL),(89,'PROCESSED SWEDES','','','210000-1184736667',1,NULL,NULL),(90,'CELERY','','','800000AE-1344577780',1,NULL,NULL),(91,'WILJA POTATOES','','','800000AC-1342766308',1,NULL,NULL),(93,'RAMOS POTS','','','800000AC-1342766308',1,NULL,NULL),(94,'ROOSTER POTS','','','800000AC-1342766308',1,NULL,NULL),(95,'TOPPED CARROT','','','F0000-1184736667',1,NULL,NULL),(96,'SPANISH CALABRESE','','','C0000-1184736667',1,NULL,NULL),(97,'POTS','','','800000AC-1342766308',1,NULL,NULL),(98,'COLT CABBAGE','','','300000-1184736667',1,NULL,NULL),(99,'COCONUT','','','800000B0-1367307897',1,NULL,NULL),(100,'PINK ONIONS','','','510000-1184736668',1,NULL,NULL),(101,'PINK CABBAGE','','','1A0000-1184736667',1,NULL,NULL),(102,'GREEN KALE','','','440000-1184736667',1,NULL,NULL),(103,'RED KALE','','','440000-1184736667',1,NULL,NULL),(104,'CAVARLERO','','','B0000-1184736667',1,NULL,NULL),(105,'SAVOY CROSS','','','B0000-1184736667',1,NULL,NULL),(106,'LINCOLN NEW POTS','','','800000AC-1342766308',1,NULL,NULL),(108,'SAXON POTS','','','800000AC-1342766308',1,NULL,NULL),(109,'CABERET POTS','','','800000AC-1342766308',1,NULL,NULL),(110,'CAVALERO','','','800000B2-1391585335',1,NULL,NULL),(111,'CHATEUX  POTS','','','800000A0-1322814334',1,NULL,NULL),(112,'SPROUT STALKS','','','80000-1184736667',1,NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productweights`
--

DROP TABLE IF EXISTS `productweights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `productweights` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(45) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `kg` decimal(16,8) DEFAULT NULL,
  `amount` decimal(16,8) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productweights`
--

LOCK TABLES `productweights` WRITE;
/*!40000 ALTER TABLE `productweights` DISABLE KEYS */;
INSERT INTO `productweights` VALUES (1,'6 KG',1,6.00000000,NULL),(2,'8 KG',1,8.00000000,NULL),(3,'4.5 KG',1,5.00000000,NULL),(4,'9 KG',1,9.00000000,NULL),(5,'5 KG',1,5.00000000,NULL),(6,'250 G',1,0.25000000,NULL),(7,'10 KG',1,10.00000000,NULL),(8,'25 KG',1,25.00000000,NULL),(9,'500 KG',1,500.00000000,NULL),(10,'520 KG',1,520.00000000,NULL),(11,'1 TON',1,1000.00000000,NULL),(12,'20 KG',1,20.00000000,NULL),(13,'18 KG',1,18.00000000,NULL),(14,'12.5 KG',1,13.00000000,NULL),(15,'12',1,NULL,NULL),(16,'9',1,NULL,NULL),(17,'8',1,NULL,NULL),(18,'575 KG',1,575.00000000,NULL),(19,'MED',NULL,NULL,NULL),(20,'XL',NULL,NULL,NULL);
/*!40000 ALTER TABLE `productweights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quickbooks_integration`
--

DROP TABLE IF EXISTS `quickbooks_integration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `quickbooks_integration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `integrationName` varchar(45) DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `additions` int(11) DEFAULT NULL,
  `deletions` int(11) DEFAULT NULL,
  `modifications` int(11) DEFAULT NULL,
  `errors` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Integration table specifying the time of the update and amount of modifications made.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quickbooks_integration`
--

LOCK TABLES `quickbooks_integration` WRITE;
/*!40000 ALTER TABLE `quickbooks_integration` DISABLE KEYS */;
/*!40000 ALTER TABLE `quickbooks_integration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sales` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `customerID` int(11) DEFAULT NULL,
  `produceID` int(11) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `haulageID` int(11) DEFAULT NULL,
  `deliveryCost` decimal(16,8) DEFAULT NULL,
  `cost` decimal(16,8) DEFAULT NULL,
  `deliveryDate` bigint(13) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `productID` int(11) DEFAULT NULL,
  `weightID` int(11) DEFAULT NULL,
  `packagingID` int(11) DEFAULT NULL,
  `descriptorID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `customerID_idx` (`customerID`),
  KEY `produceID_idx` (`produceID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliers` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `supplierName` varchar(45) NOT NULL,
  `terms` int(11) DEFAULT NULL,
  `remittanceEmail` varchar(254) DEFAULT NULL,
  `confirmationEmail` varchar(254) DEFAULT NULL,
  `addressLine1` varchar(100) DEFAULT NULL,
  `addressLine2` varchar(100) DEFAULT NULL,
  `addressLine3` varchar(100) DEFAULT NULL,
  `addressLine4` varchar(100) DEFAULT NULL,
  `addressLine5` varchar(100) DEFAULT NULL,
  `phoneNumber` varchar(45) DEFAULT NULL,
  `faxNumber` varchar(45) DEFAULT NULL,
  `quickbooksName` varchar(45) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `termsRef` varchar(45) DEFAULT NULL,
  `isEmailedRemittance` tinyint(1) DEFAULT NULL,
  `isEmailedConfirmation` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliers`
--

LOCK TABLES `suppliers` WRITE;
/*!40000 ALTER TABLE `suppliers` DISABLE KEYS */;
INSERT INTO `suppliers` VALUES (1,'Test1',42,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'',NULL,NULL,NULL,NULL),(2,'Z Another Test',NULL,NULL,NULL,'Did this','work','correctly','line4','line5',NULL,NULL,NULL,0,NULL,1,1),(3,'Z Final Supplier Test',42,NULL,NULL,'Another Test','Testing!',NULL,NULL,NULL,NULL,NULL,'800002B0-1394377833',0,'8000000D-1364633337',1,1),(4,'AIREY R.L',NULL,NULL,NULL,'A.J. Airey & Son','Windy Ridge Park Road','Stow Market','Suffock','IP14 2JP',NULL,NULL,'1A30000-1185871008',1,NULL,0,0),(5,'A C PRODUCE - SUPPLIER',0,NULL,NULL,'A C Produce Imports Ltd','Arch 23 - 24, Fruit & Vegetable Market','New Covent Garden Market','London','SW8 5PA',NULL,NULL,'80000248-1326803078',1,NULL,0,0),(6,'A D S',0,NULL,NULL,'ADS PRINT SERVICES LTD','9 Kennet Road','Dartford','Kent','DA1 4QT',NULL,NULL,'800002AF-1394102403',1,NULL,0,0),(7,'ADRRA',NULL,NULL,NULL,'Adrra Associates Ltd','No 3, Branches Lane','Holbeach','Lincolnshire','PE12 7BE','01406 423604',NULL,'340000-1184737081',1,NULL,0,0),(8,'ALLIUM ALLIANCE',0,'susan@alliumalliance.co.uk','susan@alliumalliance.co.uk','Allium Alliance Ltd','12 Enterprise Way','Pinchbeck','Lincs','PE11 3YR','017757112224','01775766841','800001D5-1214902584',1,NULL,0,0),(9,'AMTRAK',NULL,NULL,NULL,'AMTRAK',NULL,NULL,NULL,NULL,NULL,NULL,'80000276-1366801539',1,NULL,0,0),(10,'ANDERSON',NULL,NULL,NULL,'P Anderson','Ferry Lane','Brothertoft','Lincs','PE20 3SR','01205280297',NULL,'350000-1184737081',1,NULL,0,0),(11,'ASDAS',NULL,NULL,NULL,'ASDAS',NULL,NULL,NULL,NULL,NULL,NULL,'800001EB-1229427996',1,NULL,0,0),(12,'A 1 VEG (W/I)',NULL,'a1vegltd@yahoo.co.uk','a1vegltd@yahoo.co.uk','A 1 VEG (W/I)','P20-22','Western International Market','SOUTHALL','UB2 5XJ','02088480700','02088481083','8000021B-1268729919',1,NULL,0,0),(13,'A L LEE & SONS POTS',NULL,'info@allee-farms.co.uk','info@allee-farms.co.uk','A.L. LEE & SONS','The Farm Office','Whitebridge Farm','Littleport','CB6 1RT','01353669770','01353669771','8000025E-1342431474',1,NULL,0,0),(14,'ASKEWS',NULL,NULL,NULL,'S S Askews','Walkdon House Farm','Sineacre','Ormskirk L39 OHR',NULL,NULL,'01704222850','360000-1184737081',1,NULL,0,0),(15,'B D B MARKETING',NULL,'bradley.brown@hotmail.co.uk','bradley.brown@hotmail.co.uk','B D B MARKETING','62-29 LINK HOUSE, FRUIT & VEG MARKET','NEW COVENT GARDEN','VAUXHALL','SW8 5LL','02077204444','02077204808','1AD0000-1187767173',1,NULL,0,0),(16,'B.T',NULL,NULL,NULL,'B.T',NULL,NULL,NULL,NULL,NULL,NULL,'C10000-1184738547',1,NULL,0,0),(17,'BARTLETT SUP',NULL,'john@rrwbartlett.co.uk','john@rrwbartlett.co.uk','R.&R.W. Bartlett Ltd. (PH)','Shenstone Park','Little Hay','Staffs',NULL,'01543481215','01543481627','80000270-1357727161',1,NULL,0,0),(18,'BAXTER',NULL,'vivienb@madasafish.com','vivienb@madasafish.com','Baxters High Brow Produce Ltd','High Brow Farm','Georges Lane','Southport','PR9 8HD','01704212948','01704226146','390000-1184737081',1,NULL,0,0),(19,'BAXTER A.W',NULL,NULL,NULL,'A.W Baxter Produce Ltd.','Ribble Bank','Marsh Lane','Banks','PR9 8EA','01704 211211','01704 232233','1B00000-1188284341',1,NULL,0,0),(20,'BERRY',NULL,'berrybrosfarms@btconnect.com','berrybrosfarms@btconnect.com','Berry Brothers (Farms) Ltd','Crank Hall  Farm','Crank Road','MERSEYSIDE','WA11 7RX','0174428237','01744886537','3C0000-1184737081',1,NULL,0,0),(21,'BETTINSON',0,'phil.bettinson.ltd@gmail.com','phil.bettinson.ltd@gmail.com','Phil Bettinson Ltd','2 The Heights','Strawberry fields','Southampton','SO30 4QY','01489 783392','01489 781614','80000251-1332246707',1,NULL,0,0),(22,'BLAND C',NULL,NULL,NULL,'C H & D Bland Ltd','New Farm','Wigtoft Bank','Lincs','PE20 2QB','01205460276',NULL,'3D0000-1184737081',1,NULL,0,0),(23,'BNP PARIBAS',NULL,NULL,NULL,'BNP PARIBAS LEASE GROUP','Northen Cross','Basing View','Hampshire','RG21 4HL',NULL,NULL,'80000257-1335260903',1,NULL,0,0),(24,'BOOTHC',NULL,'boothsfarm@hotmail.co.uk','boothsfarm@hotmail.co.uk','C Booth','Needles Farm','Ferry Lane','Boston Lincs','PE20 3SR','01205280888',NULL,'430000-1184737081',1,NULL,0,0),(25,'BOSTON PRODUCE',NULL,'Keith.Crossingham@BostonProduce.co.uk','Keith.Crossingham@BostonProduce.co.uk','Boston Produce','Station Road','Swineshead','LINCS','PE20 3PN','01205311377','01205311091','8000022A-1284537880',1,NULL,0,0),(26,'BOSTON TRANSPORT',NULL,NULL,NULL,'BOSTON TRANSPORT','VENTURE HOUSE','ENTERPRISE WAY','LINCS','PE21 7TW',NULL,NULL,'80000231-1295517124',1,NULL,0,0),(27,'BRANDREATH FARM',0,NULL,NULL,'Brandreath Farm','Tarcsough Lane',NULL,'Burscough','L40 0RJ','01704897665','01704893512','B80000-1184737083',1,NULL,0,0),(28,'BRATLEY',NULL,'charlotte@bratley.co.uk','charlotte@bratley.co.uk','R Bratley (Quadring) Ltd','Quadring Eaudyke','Spalding','LINCS','PE11 4QB','01775840322','01775 840797','490000-1184737081',1,NULL,0,0),(29,'BREWSTER CRAVEN LTD',NULL,NULL,NULL,'BREWSTER CRAVEN LTD','44 STOCKPORT ROAD',NULL,'ROMILEY','SK6 3AG',NULL,NULL,'8000023A-1307089997',1,NULL,0,0),(30,'BUSINESS STATIONERY DIRECT',NULL,NULL,NULL,'BUSINESS STATIONERY DIRECT','Wheatfield Way','Hinckley','Leicestershire','LE10 1YG','01455 615564','01455 614141','1B50000-1190010841',1,NULL,0,0),(31,'C&A PRODUCE',NULL,NULL,NULL,'C & A Produce','Arch 21, Fruit & Vegetable Market','New Covent Garden Market','SW8',NULL,'02077 200264','0207 498867','80000245-1324554929',1,NULL,0,0),(32,'C.G.M.A',NULL,NULL,NULL,'C.G.M.A','Covent House','New Covent Garden Market','London','SW8 5NX',NULL,NULL,'C30000-1184739002',1,NULL,0,0),(33,'C.P MALLINSON',NULL,'louisemallinson@btinternet.com','louisemallinson@btinternet.com','C.P MALLINSON','44 Tabby Nwok','Nere Brow','Preston','PR4 6LA',NULL,NULL,'80000229-1283847994',1,NULL,0,0),(34,'CARLTON TOWER HOTEL',NULL,NULL,NULL,'CARLTON TOWER HOTEL',NULL,NULL,NULL,NULL,NULL,NULL,'8000029C-1393223743',1,NULL,0,0),(35,'Cartridge Shop',NULL,NULL,NULL,'Cartridge Shop','POBOX 484',NULL,NULL,NULL,NULL,NULL,'8000025B-1336987147',1,NULL,0,0),(36,'CHEFS CHOICE',NULL,'info@chefschoiceuk.com','info@chefschoiceuk.com','CHEFS CHOICE','Arch 6','Fruit & Veg Market','London','SW8 5PP',NULL,'0207 720546','80000246-1324555829',1,NULL,0,0),(37,'CLARITY COPIERS',NULL,'Marie.S@claritycopiershw.co.uk','Marie.S@claritycopiershw.co.uk','Clarity Copiers Ltd','Unit 11 Treadaway Technical Center','Treadaway Hill','High Wycombe','HP10 9RS','01628527370','01628532030','80000254-1333356315',1,NULL,0,0),(38,'CLEMENTS T.H',NULL,'enquiries@thclements.co.uk','enquiries@thclements.co.uk','T.H Clements & Son Ltd.','West End','Benington','Boston Lincolnshire','PE22 0EJ','01205760456','01205760760','800001DA-1217485533',1,NULL,0,0),(39,'CODEXO PRESTIGE',NULL,NULL,NULL,'SODEXO PRESTIGE',NULL,NULL,NULL,NULL,NULL,NULL,'8000026A-1351493980',1,NULL,0,0),(40,'COOK',0,'cookscarrots@btinternet.com','cookscarrots@btinternet.com','E Cook & Sons','Windle Hall Farm','Abbey Road','MERSEYSIDE','WA11 7RG','0174422784',NULL,'530000-1184737082',1,NULL,0,0),(41,'COSTCO WHOLESALE',NULL,NULL,NULL,'COSTCO WHOLESALE',NULL,NULL,NULL,NULL,NULL,NULL,'8000021F-1275977351',1,NULL,0,0),(42,'CREDIT SAFE',NULL,'CreditControl@creditsafeuk.com','CreditControl@creditsafeuk.com','Creditsafe Business Solutions Ltd.','Caspian Point 1','Peirhead Street','Cardiff Bay','CF10 4DQ','08708500660','02920856545','80000255-1334832698',1,NULL,0,0),(43,'D G PRODUCE',NULL,'accounts@dgproduce.com','accounts@dgproduce.com','D G PRODUCE','SYCAMORE FARM','CANNISTER LANE','FRITHVILLE','PE22 7HG',NULL,NULL,'80000243-1322559084',1,NULL,0,0),(44,'DAVENPORT TRANSPORT LTD',NULL,NULL,NULL,'Davenport Transport Ltd.','Tollgate Cresent,','Burscough,','Ormskirk.','L40 8TC.','01704 893106','01704893409','1A40000-1185871357',1,NULL,0,0),(45,'DAY2DAY',NULL,'info@day2day-stationary.co.uk','info@day2day-stationary.co.uk','Day 2 Day Stationery Ltd.','2nd Floor, 128-134 High Street',NULL,'Hornchurch','RM12 4UH','08006781018','08006781019','80000273-1364982158',1,NULL,0,0),(46,'dell',NULL,NULL,NULL,'dell',NULL,NULL,NULL,NULL,NULL,NULL,'8000024E-1331190090',1,NULL,0,0),(47,'EASEY TRANSPORT',NULL,NULL,NULL,'Brian Easy Transport Ltd','2 Park Close','Coveney, Ely','Cambs','CB6 2DH','07795 977935','01353 778649','1B20000-1188902508',1,NULL,0,0),(48,'EASY JET',NULL,NULL,NULL,'EASY JET',NULL,NULL,NULL,NULL,NULL,NULL,'8000024A-1328187044',1,NULL,0,0),(49,'EFP',NULL,NULL,NULL,'E.F.P INTERNATIONAL','P.O Box 253',NULL,'Naaldwijk','2670 AH','0031174540840',NULL,'5B0000-1184737082',1,NULL,0,0),(50,'ELEY',NULL,'info@chriseley.co.uk','info@chriseley.co.uk','Chris Eley Produce LTD','Kellet Gate','Low Fulney','Spalding Lincs','PE12 6EH','01775 766061','01775 710276','800001FA-1238138968',1,NULL,0,0),(51,'EPC',NULL,NULL,NULL,'E.P.C (UK) Ltd','E.P.C House','14 Upper Montagu Street','London','W1H 2PD',NULL,NULL,'5C0000-1184737082',1,NULL,0,0),(52,'EULER HERMES',NULL,NULL,NULL,'Euler Hermes UK','1 Canada Square',NULL,'London','F14 5DX','08443930000',NULL,'8000028B-1384343052',1,NULL,0,0),(53,'EUROFFICE',NULL,NULL,NULL,'EUROFFICE',NULL,NULL,NULL,NULL,NULL,NULL,'8000021C-1269501997',1,NULL,0,0),(54,'F.DALES & SON',NULL,NULL,NULL,'F.DALES & SON','RETREAT FARM','HUNDLEEY','LINCS','PE23 5LP',NULL,NULL,'80000207-1244710073',1,NULL,0,0),(55,'FEARNS',NULL,'margaret@fearns.uk.com','margaret@fearns.uk.com','Fearns','Redford Farm','Garvock','Kincardineshire','AB30 1HS','01561378861','01561378011','80000250-1331804355',1,NULL,0,0),(56,'FIDDLER',NULL,NULL,NULL,'R. Fiddler & Sons','Brick Kiln Farm','Brick Kiln Lane','LANCS','L40 1SY','01704821364',NULL,'5D0000-1184737082',1,NULL,0,0),(57,'FRANCIS',0,'francisandsonltd@tiscali.co.uk','francisandsonltd@tiscali.co.uk','Francis & Son Ltd','High Gate','Leverton','LINCS PE22 OAW',NULL,'01205870341','01205871447','5F0000-1184737082',1,NULL,0,0),(58,'FRANCIS TRANSPORT',NULL,NULL,NULL,'Francis & Son Ltd','LEVERTON',NULL,'BOSTON','PE22 0AW',NULL,NULL,'800001CB-1210842032',1,NULL,0,0),(59,'FRESH FOOD',NULL,'accounts@fresh-food.be','accounts@fresh-food.be','N.V. Fresh Food D.F.','Vlamingstraat 29',NULL,'Wevelgem','8560','003256432028','003256417843','600000-1184737082',1,NULL,0,0),(60,'FRESH PREP SUP',NULL,'barry.spencer@freshprep.co.uk','barry.spencer@freshprep.co.uk','Fresh Prep Ltd','Charbridge Way','Bicester Dist Park','Bicester','OX26 4SX','01869 325655',NULL,'8000025F-1343284949',1,NULL,0,0),(61,'G H CHENNELLS FARMS LTD',NULL,'annette@chennellsfarms.co.uk','annette@chennellsfarms.co.uk','G H CHENNELLS FARMS LTD','CLAY FARM','NORTH SCARLE','LINCS','LN6 9ES',NULL,NULL,'80000238-1303287229',1,NULL,0,0),(62,'GARDEN OF ELVEDEN',NULL,'sales@gardenofelveden.com','sales@gardenofelveden.com','Garden of Elveden','The Estate Office','Elveden','Thetford','IP24 3TQ','01842868062','01842890310','80000220-1276234485',1,NULL,0,0),(63,'GARRETT',NULL,'tina.garrett@btconnect.com','tina.garrett@btconnect.com','R.G Produce Limited','New College Farm','College Road','Kings Lynn','PE33 9AZ','01366500390',NULL,'610000-1184737082',1,NULL,0,0),(64,'GLS.',NULL,NULL,NULL,'GLS.',NULL,NULL,NULL,NULL,NULL,NULL,'80000260-1343286185',1,NULL,0,0),(65,'GOLDING',NULL,'wgolding@btconnect.com','wgolding@btconnect.com','Golding Farms Ltd','Little Hanging Bridge Farm','Meadow Lane','Nr Leyland','PR26 9JP','01704 821548','01704 821548','640000-1184737082',1,NULL,0,0),(66,'GOOGLE',NULL,NULL,NULL,'GOOGLE',NULL,NULL,NULL,NULL,NULL,NULL,'80000296-1388991823',1,NULL,0,0),(67,'GOSLING',NULL,NULL,NULL,'R Gosling','Elder Farm','Sutterton','Lincs','PE20 2LV','01205460357','01205461061','650000-1184737082',1,NULL,0,0),(68,'GRANT',NULL,'annp@jwgrant-farmers.co.uk','annp@jwgrant-farmers.co.uk','J.W Grant Co','Fold Hill','Old Leake','Boston Lincolnshire','PE22 9PJ','01205 872954','01205 871380','800001FB-1238402807',1,NULL,0,0),(69,'GREENS REDBEET',NULL,'mdh@spearheadgroup.co.uk','mdh@spearheadgroup.co.uk','Greens Redbeet Group','Mettleham Farm Centre','Hasse Road','Ely','CB7 5UW','01353 720158','01353 720143','660000-1184737082',1,NULL,0,0),(70,'GREENSHOOTS',NULL,'barry@tompsettgrowersltd.co.uk','barry@tompsettgrowersltd.co.uk','Greenshoots Ltd','Hollyhouse Farm','Horseway','Cambridgeshire','PE16 6XQ','01638783012','01638780018','1C50000-1204705895',1,NULL,0,0),(71,'GREENWOOD',NULL,NULL,NULL,'D Greenwood','Becconsall Farm','Marshes Lane','Nr PRESTON','TR4 6JS','01704821993',NULL,'670000-1184737082',1,NULL,0,0),(72,'GRIFFITHS TRANSPORT LTD.',NULL,'mandy@mjgriffiths.co.uk','mandy@mjgriffiths.co.uk','M.J GRIFFITHS TRANSPORT LTD.','Tollgate Crescent,','Burscough Industrial Estate,','Lancs','L40 8LT','01704 895951','01704 895952','1A10000-1185278570',1,NULL,0,0),(73,'HARS & HAGEBAUER',NULL,NULL,NULL,'Hars & Hagebauer Ltd','Transfesa Terminal','Henley Road','Kent','TN12 6UT','01892839146','01892836034','800001EC-1229506045',1,NULL,0,0),(74,'HAYMARKET',NULL,NULL,NULL,'HAYMARKET',NULL,NULL,NULL,NULL,NULL,NULL,'8000024D-1329113326',1,NULL,0,0),(75,'HESKETH',NULL,NULL,NULL,'Hesketh Bank Packaging Ltd','143 Moss lane','Hesketh Bank','Preston','PR4 6AE','01772 812468','01772 813161','1A50000-1185874529',1,NULL,0,0),(76,'HIAM FOODS',0,'office@frederick-hiam.co.uk','office@frederick-hiam.co.uk','Frederick Hiam Foods','Manor Farm','Ixworth Thorpe','SUFFOLK','IP31 1QH','01842 815500','01842 816999','6A0000-1184737082',1,NULL,0,0),(77,'HIGHFIELDS LLP',NULL,NULL,NULL,'Highfields LLP','Newfield House','Coates Farm','Nottinghamshire','DN22 0HA','01777 249392','01777 249389','800001FD-1238566252',1,NULL,0,0),(78,'HILTON WHOLESALE',NULL,'hilton@hiltonwholesale.freeserve.co.uk','hilton@hiltonwholesale.freeserve.co.uk','Hilton Wholesale','7 Brewers Court','Donington','Spalding Lincs','PE11 4US','01775 821004','01775 821008','800001EE-1231494433',1,NULL,0,0),(79,'HM CUSTOMS & EXCISE',NULL,NULL,NULL,'HM Customs & Excise',NULL,NULL,NULL,NULL,NULL,NULL,'10000-1184735988',1,NULL,0,0),(80,'HOLBERCO',NULL,NULL,NULL,'Holberco Produce Ltd','57 Lordsgate Lane','Burscough','ORMSKIRK','L40 7UR','01704894598',NULL,'6D0000-1184737082',1,NULL,0,0),(81,'HOLIDAY INN',NULL,NULL,NULL,'HOLIDAY INN',NULL,NULL,NULL,NULL,NULL,NULL,'80000262-1347859072',1,NULL,0,0),(82,'HUNT SMEE & CO.',NULL,NULL,NULL,'Hunt Smee & Co.','Acorn House','Great Oaks','Essex','SS14 1AH','01268521244','01268281772','800001D6-1217322852',1,NULL,0,0),(83,'HUNTAPAC',0,'tracey.blair@huntapac.co.uk','tracey.blair@huntapac.co.uk','Huntapac Produce Ltd','293 Blackgate Lane','Tarleton','Preston','PR4 6JJ','01772280600','01772933585','1BA0000-1196674851',1,NULL,0,0),(84,'HUNTAPAC TRANSPORT',NULL,NULL,NULL,'Huntapac Produce Ltd',NULL,NULL,NULL,NULL,NULL,NULL,'1C60000-1205741753',1,NULL,0,0),(85,'IBERVEG',NULL,'info@iberveg.com','info@iberveg.com','IBERVEG UK LTD','66-69 Link House','Fruit & Vegetable Market','Vauxhall','SW8 5PA','07956 074 778',NULL,'8000025A-1335866991',1,NULL,0,0),(86,'IDS Transport UK LTD',NULL,'chrisjones@IDStransport.co.uk','chrisjones@IDStransport.co.uk','IDS Transport UK LTD',NULL,NULL,NULL,NULL,'01386835560','01386835574','80000286-1382612788',1,NULL,0,0),(87,'ISLE',NULL,NULL,NULL,'Isle of Ely Produce Ltd','Aubrey&apos;s Yard','Pulloxhill Road','BEDS','MK45 4QT','01353863355',NULL,'740000-1184737082',1,NULL,0,0),(88,'J.M.B.',NULL,NULL,NULL,'Jmb Farming','Reeds Farm','Reeds Lane','Merseyside','WA11 7JN',NULL,NULL,'760000-1184737082',1,NULL,0,0),(89,'KNIGHTS PARTNERSHIP',NULL,NULL,NULL,'KNIGHTS PARTNERSHIP','Field Dalling Hall','Field Dalling','Holt NORFOLK','NR25 7AS','01328 830000',NULL,'7B0000-1184737082',1,NULL,0,0),(90,'LEEGWATER',NULL,'info@paulleegwater.com','info@paulleegwater.com','P.J. Leegwater B.V. lockbox 217','P.O. Box 216',NULL,'Widnes','WA8 2ZX','0031226362204',NULL,'800000-1184737082',1,NULL,0,0),(91,'LEGAL & GENERAL',NULL,NULL,NULL,'LEGAL & GENERAL','1 COLEMAN STREET',NULL,'LONDON','EC2R 5AA',NULL,NULL,'80000242-1321264806',1,NULL,0,0),(92,'LAMPSHOP',NULL,NULL,NULL,'LAMPSHOP',NULL,NULL,NULL,NULL,NULL,NULL,'80000265-1348219214',1,NULL,0,0),(93,'LEE',NULL,'jo@allee-farms.co.uk','jo@allee-farms.co.uk','A.L. Lee','White Bridge Farm','Ely Road','CAMBS','DR6 1RT','01353669770','01353669771','7F0000-1184737082',1,NULL,0,0),(94,'M I HLADUN & SON',NULL,'andrew.hladun@mod-comp.co.uk','andrew.hladun@mod-comp.co.uk','M&I HLADUN & SON','CROSS ROADS FARM','FRAMPTON FEN','LINCS','PE20 1SJ','07778747881',NULL,'800001DF-1219819670',1,NULL,0,0),(95,'MAIN LINE CO INTERNATIONAL',NULL,NULL,NULL,'MAIN LINE CO INTERNATIONAL',NULL,NULL,NULL,NULL,NULL,NULL,'80000269-1350279920',1,NULL,0,0),(96,'MAN FOODS.',NULL,'manfoods@btconnect.com','manfoods@btconnect.com','MAN FOODS.','3 Dorma Trading Est','Staffa Road','Leyton','E10 7QX','0208 5582078','0208 5396138','80000240-1320139602',1,NULL,0,0),(97,'MARSHALLS R',NULL,NULL,NULL,'R & R MARSHALLS','Moss Hall Farm','Bescar Lane','Lancs','L40 9QN','01704880449','01704889034','1AB0000-1187242041',1,NULL,0,0),(98,'McKEAN & SONS',NULL,'immckeans@btconnect.com','immckeans@btconnect.com','I&M McKean & Sons','132 Blackgate Lane','Tarleton','Lancs','PR4 6UU','01772814754',NULL,'800001CF-1212661105',1,NULL,0,0),(99,'MOLYNEUX KALE',NULL,'accounts.mkc@btconnect.com','accounts.mkc@btconnect.com','MOLYNEUX KALE COMPANY LTD','ASMALL HOUSE FARM','ASMALL LANE','LANCS','L40 8JL','01695573539','01695571064','8000027D-1373275882',1,NULL,0,0),(100,'MOORHOUSE AND MOHAN',NULL,NULL,NULL,'Moorhouse and Mohan Ltd','30-34 Commercial Road','March','Cambridgeshire','PE15 8QP','01354602860',NULL,'8000027F-1373609758',1,NULL,0,0),(101,'MOULTON BULB IMPORTS LTD',NULL,'frances@moultonbulbimports.co.uk','frances@moultonbulbimports.co.uk','MOULTON BULB IMPORTS LTD','SUITE1.10, S HARRINGTON BUILDING','182 SEFTON ST','BRUNSWICK BUSINESS PARK','L3 4BQ','01512363291','01512364677','8000023E-1311066407',1,NULL,0,0),(102,'NATIONAL RENTAL',NULL,NULL,NULL,'NATIONAL RENTAL',NULL,NULL,NULL,NULL,NULL,NULL,'80000277-1366801583',1,NULL,0,0),(103,'NATURA',NULL,NULL,NULL,'Natura Produce Ltd','Suite 404,','No 1, Alie Street','LONDON','E1 8DE',NULL,NULL,'860000-1184737082',1,NULL,0,0),(104,'PALMER D',NULL,'Nicola@beer55.wanadoo.co.uk','Nicola@beer55.wanadoo.co.uk','D Palmer','174 High Street','Lakenheath','Suffolk','IP27 9SE','01842862349',NULL,'8C0000-1184737082',1,NULL,0,0),(105,'NAYLOR PRODUCE',NULL,'sheila@naylorfarms.co.uk','sheila@naylorfarms.co.uk','Naylor Produce','Roman Bank','Moulton Seas End','Spalding Lincs','PE12 6LG','01406 370439','01406 371787','800001F5-1236936091',1,NULL,0,0),(106,'NEAL',NULL,NULL,NULL,'Neal & Co (Produce Merc) Ltd','The Grange','Benington','LINCS','PE22 0DR','01205760209',NULL,'870000-1184737082',1,NULL,0,0),(107,'NORTON',NULL,NULL,NULL,'NORTON',NULL,NULL,NULL,NULL,NULL,NULL,'80000249-1326877091',1,NULL,0,0),(108,'PALMER B',NULL,NULL,NULL,'Brian Palmer','Meadow Farm','Station Road','Suffolk','IP27 9AA','01842861669',NULL,'8B0000-1184737082',1,NULL,0,0),(109,'PARKS',NULL,'accounts@epark.co.uk','accounts@epark.co.uk','E. PARK & SONS','Lees Lane','Newton, Adlington','Chesire','SK10 4LL','01625532511',NULL,'80000201-1242121425',1,NULL,0,0),(110,'PARSONS',NULL,NULL,NULL,'T.D. Parsons & Sons','Three Ways','Tattershall Road','LINCS','PE21 9LY','01205361706',NULL,'900000-1184737082',1,NULL,0,0),(111,'PEARSON EDWARD',NULL,'Accounts@epearsontransport.co.uk','Accounts@epearsontransport.co.uk','W E & C P Pearson','9-11, Freiston Enterprise Park','Priory Road, Freiston,','LINCS PE22 OJZ',NULL,'01205761711',NULL,'910000-1184737082',1,NULL,0,0),(112,'PERCY WATTS',NULL,'adrianwattspws@rocketmail.com','adrianwattspws@rocketmail.com','Percy Watts','4 Abbey Place','Fordham','Cambs','CB7 5WF','01223860844 (wash)','07778853869 (mob)','920000-1184737082',1,NULL,0,0),(113,'PETER HATTON',NULL,'hatton.peter7@gmail.com','hatton.peter7@gmail.com','Peter Hatton Ltd','Manchester Business Park','3000 Aviator Way','Manchester','M22 5TG','01612661181',NULL,'8000026E-1354525239',1,NULL,0,0),(114,'PHOENIX',0,'kate@awphoenix.co.uk','kate@awphoenix.co.uk','A.W. Phoenix & Sons','Ivy House Farm','Brothertoft','LINCS','PE20 3SH','01205290206',NULL,'930000-1184737082',1,NULL,0,0),(115,'POOLEY',NULL,NULL,NULL,'T.Pooley','Peter House Farm','Beck Row','SUFFOLK','IP28 8BX',NULL,NULL,'940000-1184737082',1,NULL,0,0),(116,'POST OFFICE',NULL,NULL,NULL,'POST OFFICE',NULL,NULL,NULL,NULL,NULL,NULL,'8000021E-1272623925',1,NULL,0,0),(117,'PREVA',NULL,NULL,NULL,'Preva Produce Ltd','Addison Farm','Hindolveston Road','Norfolk','NR20 5SQ','01362 684300','01362 684103','960000-1184737082',1,NULL,0,0),(118,'PROCTOR & ASSOCIATES',NULL,NULL,NULL,'Proctor & Associates','Westwood House','Church Lane','Lincolnshire','PE21 7AF','01205 360189','01205 363009','800001F0-1231922487',1,NULL,0,0),(119,'PRODUCE WORLD IFP Ltd',NULL,NULL,NULL,'Produce World IFP Ltd','Whitehall Farm','Temple Road','Ely','CB7 5RF','01638 783021','01638 783041','750000-1184737082',1,NULL,0,0),(120,'Rapid Racking',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'80000261-1345118288',1,NULL,0,0),(121,'ROWE',NULL,'rowe.farming@greenvale.co.uk','rowe.farming@greenvale.co.uk','Greenvale Ltd, 7 The Forum','Minerva Business Park','Lynch Wood','Peterborough','PE2 6FT','01326565588','01733237157','800001D3-1214294691',1,NULL,0,0),(122,'SAINSBURYS',NULL,NULL,NULL,'SAINSBURYS',NULL,NULL,NULL,NULL,NULL,NULL,'800001ED-1229609740',1,NULL,0,0),(123,'PRUHEALTH',NULL,'S4@standardlifehealthcare.co.uk','S4@standardlifehealthcare.co.uk','Pruhealth','PO Box 28836',NULL,'Edinbuurgh','EH15 1WQ','08456024848','08456023001','800001D2-1214284071',1,NULL,0,0),(124,'SCOTTISH WIDOWS',NULL,NULL,NULL,'Scottish Widows',NULL,NULL,NULL,NULL,NULL,NULL,'800001DE-1219749465',1,NULL,0,0),(125,'SCOTTS FARMS',NULL,'dawn@accountqueries.co.uk','dawn@accountqueries.co.uk','Scott Farms (UK) Ltd','Unit 4C','Asparagus Way','Evesham','WR11 1GD','01386446648','01386443338','8000024F-1331201804',1,NULL,0,0),(126,'SEPHTON TRANSPORT',NULL,NULL,NULL,'Sephton Transport Ltd','Briars Lane','Lathom','Ormskirk','L40 5TQ','01704 895900','01704 897383','800001F6-1237187275',1,NULL,0,0),(127,'SHIPLEYS SUP',NULL,'shipleys@tiscali.co.uk','shipleys@tiscali.co.uk','Shipleys Food Service Ltd','Upton Court Farm','Upton Court  Road','Berks','SL3 7LU','01753 531520','01753 525155','80000252-1332247424',1,NULL,0,0),(128,'SHOP4 ALL ELECTRICAL LTD',NULL,NULL,NULL,'SHOP4 ALL ELECTRICAL LTD',NULL,NULL,NULL,NULL,NULL,NULL,'80000274-1365574260',1,NULL,0,0),(129,'SIMPLY BUSINESS',NULL,NULL,NULL,'Simply Business','One Finsbury Square','London','EC2A1AE',NULL,NULL,NULL,'80000225-1280391989',1,NULL,0,0),(130,'SKYPE',NULL,NULL,NULL,'Skye Comminixations S.A.R.L 6e Etage','22/24 Boulevard Royal',NULL,'Luxembourg','L-2449',NULL,NULL,'80000256-1335159466',1,NULL,0,0),(131,'STAPLE',NULL,'accounts@staplesvegetables.co.uk','accounts@staplesvegetables.co.uk','Staples Vegetables Ltd','Marsh Farm','Sea Lane, Wrangle','LINCS','PE22 9HE','01205872902','01205872901','A60000-1184737083',1,NULL,0,0),(132,'STEWARTS',0,'sales@stewartsoftayside.co.uk','sales@stewartsoftayside.co.uk','Stewarts of Tayside Ltd','Toft Hill','Glencarse','Scotland','PH2 7LF','01738860370','01738860302','A70000-1184737083',1,NULL,0,0),(133,'SUTTON I',0,NULL,NULL,'Suttons Produce','Rose Farm','Gorse Lane','LANCS','BR4 6LJ','01772812856','01772814208','A90000-1184737083',1,NULL,0,0),(134,'T-MOBILE/EE',NULL,NULL,NULL,'Customer Services','Everything Everywhere Limited','6 Camberwell Way','Sunderland','SR3 3XN','08454125000',NULL,'80000253-1332502898',1,NULL,0,0),(135,'T.C.K',NULL,'julie@tckproduce.com','julie@tckproduce.com','TCK Fresh Produce Ltd','TCK House','Caxton Trading Estate','HAYES MIDDX','UB3 1BE','02088137647','02088135838','800001EA-1228988409',1,NULL,0,0),(136,'TESCO',NULL,NULL,NULL,'TESCO',NULL,NULL,NULL,NULL,NULL,NULL,'80000232-1296121237',1,NULL,0,0),(137,'THOROLDS',NULL,NULL,NULL,'PETER.C.THOROLDS LTD','BANK HOUSE FARM','COOKS ROAD','LINCS','PE11 4PE','01775840360',NULL,'80000202-1243492044',1,NULL,0,0),(138,'TSO HOST',NULL,NULL,NULL,'TSO HOST',NULL,NULL,NULL,NULL,NULL,NULL,'80000272-1362381591',1,NULL,0,0),(139,'TUPLINS',NULL,'tuplinandsonltd@gmail.com','tuplinandsonltd@gmail.com','Tuplin & Son Ltd','Yawlingate Road','Friskney','Boston Lincs','PE22 8QF','01754820277','01754820760','800001D8-1217404815',1,NULL,0,0),(140,'VAN RIJN',NULL,NULL,NULL,'Van Rijn Trading B.V','P.O.Box 98','2685 ZH Poeldijk','NEDERLAND',NULL,NULL,NULL,'AF0000-1184737083',1,NULL,0,0),(141,'VERGRO',NULL,'info@vergro.com','info@vergro.com','VERGRO N.V.','Kleine Roeselarestraat 5','B 8760 MEULEBEKE','BELGIE/BELGIQUE',NULL,'0032473964954','003251489606','B00000-1184737083',1,NULL,0,0),(142,'UK OFFICE DIRECT',NULL,NULL,NULL,'UK Office Direct',NULL,NULL,NULL,NULL,NULL,NULL,'130001-1194330758',1,NULL,0,0),(143,'VIKING DIRECT',NULL,NULL,NULL,'VIKING DIRECT',NULL,NULL,NULL,NULL,NULL,NULL,'C20000-1184738661',1,NULL,0,0),(144,'VIRGIN MONEY',NULL,NULL,NULL,'VIRGIN MONEY',NULL,NULL,NULL,NULL,NULL,NULL,'80000263-1347863793',1,NULL,0,0),(145,'VISTAPRINT',NULL,NULL,NULL,'VISTAPRINT',NULL,NULL,NULL,NULL,NULL,NULL,'1A00000-1185278283',1,NULL,0,0),(146,'WANDSWORTH BOROUGH COUNCIL',NULL,NULL,NULL,'Wandsworth Borough Council','Business Rates Service','Liberata UK Ltd','London','SE1 9ZN','0207 378 5941','0207 378 5901','1C00000-1200913800',1,NULL,0,0),(147,'WELLWORKING LTD',NULL,'INFO@WELLWORKING.CO.UK','INFO@WELLWORKING.CO.UK','WELLWORKING LTD','UNIT 18 ALLIANCE COURT','ALLIANCE ROAD','LONDON','W3 0RB','02031100610',NULL,'80000239-1305792406',1,NULL,0,0),(148,'WHITES',NULL,NULL,NULL,'White&apos;s Transport Ltd','Telegraph Hill Industrial Estate','Minster, Ramsgate','Kent','CT12 4HY','01843821377','01843822530','90001-1195134045',1,NULL,0,0),(149,'WISKERKE',0,'accounting@wiskerke-onions.nl','accounting@wiskerke-onions.nl','Jacob Wiskerke & ZN BV','Postbus 8',NULL,'Kruiningen','4416 ZG','003111382210','0031113381223','B90000-1184737083',1,'40000-1184735879',1,1),(150,'WRANGLE',NULL,NULL,NULL,'Wrangle Growers Ltd','Main Road','Wrangle','LINCS','PE22 9AA',NULL,NULL,'BA0000-1184737083',1,NULL,0,0),(151,'XBRIDGE LTD',NULL,NULL,NULL,'XBRIDGE LTD','ONE FINSBURY SQUARE',NULL,'LONDON','EC2A 1AE',NULL,NULL,'8000020E-1249381655',1,NULL,0,0);
/*!40000 ALTER TABLE `suppliers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport`
--

DROP TABLE IF EXISTS `transport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transport` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `remittanceEmail` varchar(254) DEFAULT NULL,
  `transportSheetEmail` varchar(254) DEFAULT NULL,
  `surcharges` blob,
  `quickbooksName` varchar(45) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `terms` int(11) DEFAULT NULL,
  `termsRef` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport`
--

LOCK TABLES `transport` WRITE;
/*!40000 ALTER TABLE `transport` DISABLE KEYS */;
INSERT INTO `transport` VALUES (1,'PEARSONS','','transport@epearsontransport.co.uk','2014-03-10:10.0','910000-1184737082',1,NULL,NULL),(2,'DELIVERED','','','','',1,NULL,NULL),(3,'EX-YARD','','','','',1,NULL,NULL),(4,'GRIFFITHS','','','','1A10000-1185278570',1,NULL,NULL),(5,'IDS','','','','80000286-1382612788',1,NULL,NULL),(6,'DAVENPORT','','','','1A40000-1185871357',1,NULL,NULL),(7,'N/A','','','','',1,NULL,NULL);
/*!40000 ALTER TABLE `transport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transport_haulage_costs`
--

DROP TABLE IF EXISTS `transport_haulage_costs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transport_haulage_costs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `transportID` int(11) DEFAULT NULL,
  `locationID` int(11) DEFAULT NULL,
  `cost` decimal(16,8) DEFAULT NULL,
  `canDeliver` int(11) DEFAULT NULL,
  `isActive` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transport_haulage_costs`
--

LOCK TABLES `transport_haulage_costs` WRITE;
/*!40000 ALTER TABLE `transport_haulage_costs` DISABLE KEYS */;
/*!40000 ALTER TABLE `transport_haulage_costs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(64) DEFAULT NULL,
  `permissions` blob,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Tom','roflman1','*,permissions.*',NULL),(2,'Bryan','killick1','*',NULL),(3,'Paul','killick1','*',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-03-14 11:04:13
