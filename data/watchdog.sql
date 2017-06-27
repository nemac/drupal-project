
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
DROP TABLE IF EXISTS `watchdog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `watchdog` (
  `wid` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Primary Key: Unique watchdog event ID.',
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'The users.uid of the user who triggered the event.',
  `type` varchar(64) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'Type of log message, for example "user" or "page not found."',
  `message` longtext NOT NULL COMMENT 'Text of log message to be passed into the t() function.',
  `variables` longblob NOT NULL COMMENT 'Serialized array of variables that match the message string and that is passed into the t() function.',
  `severity` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'The severity level of the event. ranges from 0 (Emergency) to 7 (Debug)',
  `link` text COMMENT 'Link to view the result of the event.',
  `location` text NOT NULL COMMENT 'URL of the origin of the event.',
  `referer` text COMMENT 'URL of referring page.',
  `hostname` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'Hostname of the user who triggered the event.',
  `timestamp` int(11) NOT NULL DEFAULT '0' COMMENT 'Unix timestamp of when event occurred.',
  PRIMARY KEY (`wid`),
  KEY `type` (`type`),
  KEY `uid` (`uid`),
  KEY `severity` (`severity`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COMMENT='Table that contains logs of all system events.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `watchdog` WRITE;
/*!40000 ALTER TABLE `watchdog` DISABLE KEYS */;
REPLACE INTO `watchdog` VALUES
(1,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:5:\"dblog\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568109);
REPLACE INTO `watchdog` VALUES
(2,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:18:\"dynamic_page_cache\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568114);
REPLACE INTO `watchdog` VALUES
(3,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:8:\"field_ui\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568119);
REPLACE INTO `watchdog` VALUES
(4,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:7:\"history\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568124);
REPLACE INTO `watchdog` VALUES
(5,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:8:\"taxonomy\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568130);
REPLACE INTO `watchdog` VALUES
(6,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:4:\"help\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568135);
REPLACE INTO `watchdog` VALUES
(7,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:5:\"image\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568141);
REPLACE INTO `watchdog` VALUES
(8,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:4:\"link\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568146);
REPLACE INTO `watchdog` VALUES
(9,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:17:\"menu_link_content\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568152);
REPLACE INTO `watchdog` VALUES
(10,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:7:\"menu_ui\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568158);
REPLACE INTO `watchdog` VALUES
(11,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:7:\"toolbar\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568164);
REPLACE INTO `watchdog` VALUES
(12,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:10:\"page_cache\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568170);
REPLACE INTO `watchdog` VALUES
(13,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:4:\"path\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568176);
REPLACE INTO `watchdog` VALUES
(14,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:9:\"quickedit\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568182);
REPLACE INTO `watchdog` VALUES
(15,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:3:\"rdf\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568188);
REPLACE INTO `watchdog` VALUES
(16,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:6:\"search\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568194);
REPLACE INTO `watchdog` VALUES
(17,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:8:\"shortcut\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568201);
REPLACE INTO `watchdog` VALUES
(18,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:5:\"views\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568208);
REPLACE INTO `watchdog` VALUES
(19,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:8:\"views_ui\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568214);
REPLACE INTO `watchdog` VALUES
(20,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:4:\"tour\";}',6,'','http://nemac.local/core/install.php/?_format=json&id=1&langcode=en&op=do&op=do_nojs&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568221);
REPLACE INTO `watchdog` VALUES
(21,0,'system','%theme theme installed.','a:1:{s:6:\"%theme\";s:6:\"stable\";}',6,'','http://nemac.local/core/install.php/?langcode=en&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568228);
REPLACE INTO `watchdog` VALUES
(22,0,'system','%theme theme installed.','a:1:{s:6:\"%theme\";s:6:\"classy\";}',6,'','http://nemac.local/core/install.php/?langcode=en&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568228);
REPLACE INTO `watchdog` VALUES
(23,0,'system','%theme theme installed.','a:1:{s:6:\"%theme\";s:6:\"bartik\";}',6,'','http://nemac.local/core/install.php/?langcode=en&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568228);
REPLACE INTO `watchdog` VALUES
(24,0,'system','%theme theme installed.','a:1:{s:6:\"%theme\";s:5:\"seven\";}',6,'','http://nemac.local/core/install.php/?langcode=en&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568228);
REPLACE INTO `watchdog` VALUES
(25,0,'system','%module module installed.','a:1:{s:7:\"%module\";s:8:\"standard\";}',6,'','http://nemac.local/core/install.php/?langcode=en&profile=standard&rewrite=ok&rewrite=ok','http://nemac.local/core/install.php?rewrite=ok&langcode=en&profile=standard&id=1&op=start','192.168.99.1',1498568242);
/*!40000 ALTER TABLE `watchdog` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

