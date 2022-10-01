-- MySQL dump 10.13  Distrib 8.0.30, for macos12.4 (x86_64)
--
-- Host: wardrobe.cexowvexr0ri.us-east-1.rds.amazonaws.com    Database: wardrobe
-- ------------------------------------------------------
-- Server version	5.7.33-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `id` char(36) CHARACTER SET latin1 COLLATE latin1_bin NOT NULL,
  `email` varchar(128) NOT NULL,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES ('004ff8bf-5f66-4a4f-a8f9-a119a9a14a9e','allison@wardrobe.nyc','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-03-24 19:27:24'),('055f7e6b-7897-47ea-b5e7-e074552e3204','oscmejia@vovsolutions.com','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-03-24 19:27:24'),('057a7346-067c-46d4-95b6-5a31245c23e0','gillis@wardrobe.nyc','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-03-24 19:27:24'),('2439100d-85b3-4930-ba7e-6dc675f197b5','shane@wardrobe.nyc','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-03-24 19:27:24'),('31617296-c8dd-4d1b-8fc8-99c6363ccf91','jporras@vovsolutions.com','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-07-31 14:29:16'),('6ecbac39-cbd5-442a-b1e0-41761cc82937','gmoreno@vovsolutions.com','Gustavo','Moreno','$2b$05$aevZYFhihj8WSK0gKhkV0edR5y.bpIj6R6ZsMDHm8sGFqvM.eyY3u','active','2020-03-24 19:27:24','2020-09-30 13:03:19'),('6ecbac39-cbd5-442a-b1e0-41761cc82938','ncardona@vovsolutions.com','default first name','default first name','$2b$05$aevZYFhihj8WSK0gKhkV0edR5y.bpIj6R6ZsMDHm8sGFqvM.eyY3u','active','2020-03-24 19:27:24','2020-09-30 13:03:19'),('6ecbac39-cbd5-442a-b1e0-41761cc82939','rescandon@vovsolutions.com','default first name','default first name','$2b$05$aevZYFhihj8WSK0gKhkV0edR5y.bpIj6R6ZsMDHm8sGFqvM.eyY3u','active','2020-03-24 19:27:24','2020-09-30 13:03:19'),('729f7317-5f25-4cd2-a013-973aea291e76','edwin@bsquaredpartners.com','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-03-24 19:27:24'),('729f7317-5f25-4cd2-a013-973aea291e77','randy@astruct.co','default first name','default last name','$2b$05$0rrLrjMpn5214EGDi.ScNurpDHi7.Xg5wQF8HRyhewunXCIsN.Y6O','active','2020-03-24 19:27:24','2020-03-24 19:27:24'),('7f8352c9-17f8-4398-8e58-842531c0dfe4','sasha@wardrobe.nyc','default first name','default last name','$2b$05$IAfOLdtJCwtAH4yU5C.j2ePz8cx49otmv.jruRjkx2sQiE5Uluxfq','active','2020-03-24 19:27:24','2021-04-16 16:14:39');
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;
