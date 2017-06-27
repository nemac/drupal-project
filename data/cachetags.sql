
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
DROP TABLE IF EXISTS `cachetags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cachetags` (
  `tag` varchar(255) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'Namespace-prefixed tag string.',
  `invalidations` int(11) NOT NULL DEFAULT '0' COMMENT 'Number incremented when the tag is invalidated.',
  PRIMARY KEY (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Cache table for tracking cache tag invalidations.';
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `cachetags` WRITE;
/*!40000 ALTER TABLE `cachetags` DISABLE KEYS */;
REPLACE INTO `cachetags` VALUES
('4xx-response',41);
REPLACE INTO `cachetags` VALUES
('block_content_view',1);
REPLACE INTO `cachetags` VALUES
('breakpoints',31);
REPLACE INTO `cachetags` VALUES
('comment_view',1);
REPLACE INTO `cachetags` VALUES
('config:action_list',4);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_account_menu',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_branding',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_breadcrumbs',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_content',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_footer',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_help',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_local_actions',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_local_tasks',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_main_menu',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_messages',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_page_title',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_powered',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_search',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.bartik_tools',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_breadcrumbs',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_content',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_help',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_local_actions',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_login',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_messages',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_page_title',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_primary_local_tasks',1);
REPLACE INTO `cachetags` VALUES
('config:block.block.seven_secondary_local_tasks',1);
REPLACE INTO `cachetags` VALUES
('config:block_content_type_list',1);
REPLACE INTO `cachetags` VALUES
('config:block_list',1);
REPLACE INTO `cachetags` VALUES
('config:comment_type_list',1);
REPLACE INTO `cachetags` VALUES
('config:contact_form_list',2);
REPLACE INTO `cachetags` VALUES
('config:core.extension',43);
REPLACE INTO `cachetags` VALUES
('config:core.menu.static_menu_link_overrides',1);
REPLACE INTO `cachetags` VALUES
('config:editor_list',1);
REPLACE INTO `cachetags` VALUES
('config:entity_form_display_list',1);
REPLACE INTO `cachetags` VALUES
('config:entity_form_mode_list',1);
REPLACE INTO `cachetags` VALUES
('config:entity_view_display_list',1);
REPLACE INTO `cachetags` VALUES
('config:entity_view_mode_list',5);
REPLACE INTO `cachetags` VALUES
('config:filter_format_list',2);
REPLACE INTO `cachetags` VALUES
('config:image_style_list',1);
REPLACE INTO `cachetags` VALUES
('config:menu_list',1);
REPLACE INTO `cachetags` VALUES
('config:node.settings',1);
REPLACE INTO `cachetags` VALUES
('config:node_type_list',1);
REPLACE INTO `cachetags` VALUES
('config:rdf_mapping_list',1);
REPLACE INTO `cachetags` VALUES
('config:search_page_list',1);
REPLACE INTO `cachetags` VALUES
('config:shortcut.set.default',1);
REPLACE INTO `cachetags` VALUES
('config:shortcut_set_list',2);
REPLACE INTO `cachetags` VALUES
('config:system.file',1);
REPLACE INTO `cachetags` VALUES
('config:system.menu.account',40);
REPLACE INTO `cachetags` VALUES
('config:system.menu.admin',41);
REPLACE INTO `cachetags` VALUES
('config:system.menu.footer',24);
REPLACE INTO `cachetags` VALUES
('config:system.menu.main',39);
REPLACE INTO `cachetags` VALUES
('config:system.menu.tools',37);
REPLACE INTO `cachetags` VALUES
('config:system.site',2);
REPLACE INTO `cachetags` VALUES
('config:taxonomy_vocabulary_list',1);
REPLACE INTO `cachetags` VALUES
('config:tour_list',1);
REPLACE INTO `cachetags` VALUES
('config:user.role.anonymous',2);
REPLACE INTO `cachetags` VALUES
('config:user.role.authenticated',2);
REPLACE INTO `cachetags` VALUES
('config:user.settings',1);
REPLACE INTO `cachetags` VALUES
('config:user_role_list',3);
REPLACE INTO `cachetags` VALUES
('config:views.view.archive',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.block_content',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.comments_recent',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.content',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.content_recent',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.files',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.frontpage',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.glossary',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.taxonomy_term',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.user_admin_people',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.who_s_new',1);
REPLACE INTO `cachetags` VALUES
('config:views.view.who_s_online',1);
REPLACE INTO `cachetags` VALUES
('config:view_list',1);
REPLACE INTO `cachetags` VALUES
('contextual_links_plugins',41);
REPLACE INTO `cachetags` VALUES
('element_info_build',41);
REPLACE INTO `cachetags` VALUES
('entity_bundles',67);
REPLACE INTO `cachetags` VALUES
('entity_field_info',81);
REPLACE INTO `cachetags` VALUES
('entity_types',75);
REPLACE INTO `cachetags` VALUES
('http_response',41);
REPLACE INTO `cachetags` VALUES
('link_relation_type',41);
REPLACE INTO `cachetags` VALUES
('local_action',41);
REPLACE INTO `cachetags` VALUES
('local_task',42);
REPLACE INTO `cachetags` VALUES
('node_view',1);
REPLACE INTO `cachetags` VALUES
('rendered',3);
REPLACE INTO `cachetags` VALUES
('routes',41);
REPLACE INTO `cachetags` VALUES
('route_match',41);
REPLACE INTO `cachetags` VALUES
('taxonomy_term_view',1);
REPLACE INTO `cachetags` VALUES
('theme_registry',42);
REPLACE INTO `cachetags` VALUES
('user:1',1);
REPLACE INTO `cachetags` VALUES
('user_list',2);
REPLACE INTO `cachetags` VALUES
('user_view',1);
REPLACE INTO `cachetags` VALUES
('views_data',1);
/*!40000 ALTER TABLE `cachetags` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

