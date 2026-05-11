/*
 Navicat MySQL Data Transfer

 Source Server         : mysql57
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : localhost:3306
 Source Schema         : db_order

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 17/04/2023 00:12:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 49 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add food', 7, 'add_food');
INSERT INTO `auth_permission` VALUES (26, 'Can change food', 7, 'change_food');
INSERT INTO `auth_permission` VALUES (27, 'Can delete food', 7, 'delete_food');
INSERT INTO `auth_permission` VALUES (28, 'Can view food', 7, 'view_food');
INSERT INTO `auth_permission` VALUES (29, 'Can add foodtype', 8, 'add_foodtype');
INSERT INTO `auth_permission` VALUES (30, 'Can change foodtype', 8, 'change_foodtype');
INSERT INTO `auth_permission` VALUES (31, 'Can delete foodtype', 8, 'delete_foodtype');
INSERT INTO `auth_permission` VALUES (32, 'Can view foodtype', 8, 'view_foodtype');
INSERT INTO `auth_permission` VALUES (33, 'Can add order', 9, 'add_order');
INSERT INTO `auth_permission` VALUES (34, 'Can change order', 9, 'change_order');
INSERT INTO `auth_permission` VALUES (35, 'Can delete order', 9, 'delete_order');
INSERT INTO `auth_permission` VALUES (36, 'Can view order', 9, 'view_order');
INSERT INTO `auth_permission` VALUES (37, 'Can add staff', 10, 'add_staff');
INSERT INTO `auth_permission` VALUES (38, 'Can change staff', 10, 'change_staff');
INSERT INTO `auth_permission` VALUES (39, 'Can delete staff', 10, 'delete_staff');
INSERT INTO `auth_permission` VALUES (40, 'Can view staff', 10, 'view_staff');
INSERT INTO `auth_permission` VALUES (41, 'Can add staff_ table', 11, 'add_staff_table');
INSERT INTO `auth_permission` VALUES (42, 'Can change staff_ table', 11, 'change_staff_table');
INSERT INTO `auth_permission` VALUES (43, 'Can delete staff_ table', 11, 'delete_staff_table');
INSERT INTO `auth_permission` VALUES (44, 'Can view staff_ table', 11, 'view_staff_table');
INSERT INTO `auth_permission` VALUES (45, 'Can add order item', 12, 'add_orderitem');
INSERT INTO `auth_permission` VALUES (46, 'Can change order item', 12, 'change_orderitem');
INSERT INTO `auth_permission` VALUES (47, 'Can delete order item', 12, 'delete_orderitem');
INSERT INTO `auth_permission` VALUES (48, 'Can view order item', 12, 'view_orderitem');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$260000$08eHOQeWEtLT7lCwXaRfMT$So9PyGwJW4rNgzE0tLaqZiF8tdx/OKv6ihtx1OEfm7s=', '2023-04-16 23:26:53.886942', 1, 'admin', '', '', '', 1, 1, '2023-04-15 08:27:18.780280');
INSERT INTO `auth_user` VALUES (2, 'pbkdf2_sha256$260000$oIOnCQQqzHfJQxk8UBEFSN$DOazcE+6LYkjbQAGXqn5/Hn1p1CnJNT88Anqe2JA6qM=', '2023-04-16 22:27:50.906186', 0, 'bhml', '', '', '', 0, 1, '2023-04-15 21:07:28.200428');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2023-04-15 20:48:46.950724', '1', 'bhml', 1, '[{\"added\": {}}]', 10, 1);
INSERT INTO `django_admin_log` VALUES (2, '2023-04-15 20:48:51.924701', '1', 'bhml', 2, '[]', 10, 1);
INSERT INTO `django_admin_log` VALUES (3, '2023-04-15 21:13:57.915265', '2', '高启强', 1, '[{\"added\": {}}]', 10, 1);
INSERT INTO `django_admin_log` VALUES (4, '2023-04-15 21:14:42.879762', '1', '1 一号桌', 1, '[{\"added\": {}}]', 11, 1);
INSERT INTO `django_admin_log` VALUES (5, '2023-04-15 21:14:56.921945', '1', '川菜', 1, '[{\"added\": {}}]', 8, 1);
INSERT INTO `django_admin_log` VALUES (6, '2023-04-15 21:15:27.714629', '1', '蒜苗回锅肉', 1, '[{\"added\": {}}]', 7, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (7, 'OrderSystem', 'food');
INSERT INTO `django_content_type` VALUES (8, 'OrderSystem', 'foodtype');
INSERT INTO `django_content_type` VALUES (9, 'OrderSystem', 'order');
INSERT INTO `django_content_type` VALUES (12, 'OrderSystem', 'orderitem');
INSERT INTO `django_content_type` VALUES (10, 'OrderSystem', 'staff');
INSERT INTO `django_content_type` VALUES (11, 'OrderSystem', 'staff_table');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'OrderSystem', '0001_initial', '2023-04-15 08:26:06.556567');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0001_initial', '2023-04-15 08:26:06.995299');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2023-04-15 08:26:14.353067');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0001_initial', '2023-04-15 08:26:15.923837');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0002_logentry_remove_auto_add', '2023-04-15 08:26:15.943054');
INSERT INTO `django_migrations` VALUES (6, 'admin', '0003_logentry_add_action_flag_choices', '2023-04-15 08:26:15.964135');
INSERT INTO `django_migrations` VALUES (7, 'contenttypes', '0002_remove_content_type_name', '2023-04-15 08:26:16.985171');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0002_alter_permission_name_max_length', '2023-04-15 08:26:17.476236');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0003_alter_user_email_max_length', '2023-04-15 08:26:18.317221');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0004_alter_user_username_opts', '2023-04-15 08:26:18.338841');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0005_alter_user_last_login_null', '2023-04-15 08:26:19.170970');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0006_require_contenttypes_0002', '2023-04-15 08:26:19.232943');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0007_alter_validators_add_error_messages', '2023-04-15 08:26:19.260394');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0008_alter_user_username_max_length', '2023-04-15 08:26:20.169860');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0009_alter_user_last_name_max_length', '2023-04-15 08:26:20.636013');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0010_alter_group_name_max_length', '2023-04-15 08:26:21.173598');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0011_update_proxy_permissions', '2023-04-15 08:26:21.204666');
INSERT INTO `django_migrations` VALUES (18, 'auth', '0012_alter_user_first_name_max_length', '2023-04-15 08:26:21.739249');
INSERT INTO `django_migrations` VALUES (19, 'sessions', '0001_initial', '2023-04-15 08:26:22.135531');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('2u8l0g8zvgvma1eezh98nxr7xizjs0zt', '.eJxVjMsOwiAQRf-FtSEFhkdduu83kGEYpWogKe3K-O_apAvd3nPOfYmI21ri1nmJcxZnocTpd0tID647yHestyap1XWZk9wVedAup5b5eTncv4OCvXzrRGgywNWi4TCMLg2kPWmtwCMYo0fAQOAtJEXsXc6ULHsbHDqFClm8P-IrN_E:1po3bG:A06g0PwRIGCF0XbE3dNYjorGsmRPVT0BMWGdqVnxeZM', '2023-04-30 22:43:30.714040');
INSERT INTO `django_session` VALUES ('345jh8vbzpzl8xxzcr4mw4eic76bvifw', 'e30:1po3LA:bH2GuPGA9Hb3lXSMmDRqoilH3dTcQ3FjcKrWwh-g1Qo', '2023-04-30 22:26:52.027378');
INSERT INTO `django_session` VALUES ('4p3u05y1di2ghzmt0434os1s0803dg53', '.eJxVjMsOwiAQRf-FtSHhJeDSvd9AZphBqgaS0q4a_12bdKHbe865m0iwLjWtg-c0kbgILU6_G0J-ctsBPaDdu8y9LfOEclfkQYe8deLX9XD_DiqM-q0DUjj7SIqDjpDRKNYELlgMVrHBYJxX4DJbQJsLIkWNxXEuupCnKN4f-xM5Lw:1pnyIs:U_sbnYmmqg50fypptxaP6KSgTapp1lPMArUGRRlVL_M', '2023-04-30 17:04:10.778753');
INSERT INTO `django_session` VALUES ('71jbm8fcm0rs62pjyuppqe17aml9pxn5', '.eJxVjMsOwiAQRf-FtSEFhkdduu83kGEYpWogKe3K-O_apAvd3nPOfYmI21ri1nmJcxZnocTpd0tID647yHestyap1XWZk9wVedAup5b5eTncv4OCvXzrRGgywNWi4TCMLg2kPWmtwCMYo0fAQOAtJEXsXc6ULHsbHDqFClm8P-IrN_E:1pngBD:McTTr1jtE6ta8liNs5ESELeRzvS5e0wizHvk22FEAvw', '2023-04-29 21:43:03.968895');
INSERT INTO `django_session` VALUES ('8egmc6ocrdgbbu46kcfw4ykvx3xjamij', '.eJxVjMsOwiAQRf-FtSEFhkdduu83kGEYpWogKe3K-O_apAvd3nPOfYmI21ri1nmJcxZnocTpd0tID647yHestyap1XWZk9wVedAup5b5eTncv4OCvXzrRGgywNWi4TCMLg2kPWmtwCMYo0fAQOAtJEXsXc6ULHsbHDqFClm8P-IrN_E:1po2Qo:hW8RV1uD-UAxHLk3077RCfxPgm6eS651tI6dOldiQ4I', '2023-04-30 21:28:38.113963');
INSERT INTO `django_session` VALUES ('9kn9g4a448aj7pp5u3u2ww77y6bzwz2s', 'e30:1po3Kw:JHlVulXrJbubJHN7RqFWJVhy2yUab_9VyxnNh3VTyR0', '2023-04-30 22:26:38.692999');
INSERT INTO `django_session` VALUES ('f0taz8rh4iezb2akrz4os76yl1de0ly4', '.eJxVjMsOwiAQRf-FtSEFhkdduu83kGEYpWogKe3K-O_apAvd3nPOfYmI21ri1nmJcxZnocTpd0tID647yHestyap1XWZk9wVedAup5b5eTncv4OCvXzrRGgywNWi4TCMLg2kPWmtwCMYo0fAQOAtJEXsXc6ULHsbHDqFClm8P-IrN_E:1pngRo:pt0N7ARTR8lPj4K3CrXMHle0WtfztLtu7Uujkz8OgII', '2023-04-29 22:00:12.862650');
INSERT INTO `django_session` VALUES ('gr3mz27kkjiw3d9htkxdkip7eemvpnhs', '.eJxVjMsOwiAQRf-FtSHhJeDSvd9AZphBqgaS0q4a_12bdKHbe865m0iwLjWtg-c0kbgILU6_G0J-ctsBPaDdu8y9LfOEclfkQYe8deLX9XD_DiqM-q0DUjj7SIqDjpDRKNYELlgMVrHBYJxX4DJbQJsLIkWNxXEuupCnKN4f-xM5Lw:1pnyJC:ccBhoENg5JIlBJQr-_rwF-ZpF6jaGBZ842FCbyqPnlw', '2023-04-30 17:04:30.052855');
INSERT INTO `django_session` VALUES ('rw92cr4xhtzbqfecgqktz2c68w6wklyr', 'e30:1pny9I:p_R3zzm761kInLF5-d7fTcPhb5DgfSP4VuMwQg9OCHI', '2023-04-30 16:54:16.277239');
INSERT INTO `django_session` VALUES ('s51eftt8vv17lajt0nrcrj6791xejeb1', '.eJxVjMsOwiAQRf-FtSEFhkdduu83kGEYpWogKe3K-O_apAvd3nPOfYmI21ri1nmJcxZnocTpd0tID647yHestyap1XWZk9wVedAup5b5eTncv4OCvXzrRGgywNWi4TCMLg2kPWmtwCMYo0fAQOAtJEXsXc6ULHsbHDqFClm8P-IrN_E:1po4HF:mpYjM5YZMmIPap3PT5qQp9wTA6pk9S7FsMpKa8xFUhY', '2023-04-30 23:26:53.930915');
INSERT INTO `django_session` VALUES ('xh8yq3gllk5lug3bsecrzdcyom41ua2r', '.eJxVjMsOwiAQRf-FtSEFhkdduu83kGEYpWogKe3K-O_apAvd3nPOfYmI21ri1nmJcxZnocTpd0tID647yHestyap1XWZk9wVedAup5b5eTncv4OCvXzrRGgywNWi4TCMLg2kPWmtwCMYo0fAQOAtJEXsXc6ULHsbHDqFClm8P-IrN_E:1pnhN6:AxFqhIyBKcAEGiWYBD8wGIf_giYJQ8QszQVbX-Qeo2o', '2023-04-29 22:59:24.590124');

-- ----------------------------
-- Table structure for ordersystem_food
-- ----------------------------
DROP TABLE IF EXISTS `ordersystem_food`;
CREATE TABLE `ordersystem_food`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `amount` int(11) NOT NULL,
  `price` double NOT NULL,
  `cost_time` int(11) NOT NULL,
  `foodType_id` int(11) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `OrderSystem_food_foodType_id_2a1f253e_fk_OrderSystem_foodtype_ID`(`foodType_id`) USING BTREE,
  CONSTRAINT `OrderSystem_food_foodType_id_2a1f253e_fk_OrderSystem_foodtype_ID` FOREIGN KEY (`foodType_id`) REFERENCES `ordersystem_foodtype` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordersystem_food
-- ----------------------------
INSERT INTO `ordersystem_food` VALUES (1, '蒜苗回锅肉', 85, 15, 10, 1);
INSERT INTO `ordersystem_food` VALUES (2, '重庆鸡公煲', 98, 20, 15, 4);
INSERT INTO `ordersystem_food` VALUES (3, '重庆黄焖鸡', 99, 10, 5, 4);

-- ----------------------------
-- Table structure for ordersystem_foodtype
-- ----------------------------
DROP TABLE IF EXISTS `ordersystem_foodtype`;
CREATE TABLE `ordersystem_foodtype`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordersystem_foodtype
-- ----------------------------
INSERT INTO `ordersystem_foodtype` VALUES (1, '川菜');
INSERT INTO `ordersystem_foodtype` VALUES (4, '重庆特色');

-- ----------------------------
-- Table structure for ordersystem_order
-- ----------------------------
DROP TABLE IF EXISTS `ordersystem_order`;
CREATE TABLE `ordersystem_order`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `create_time` datetime(6) NOT NULL,
  `pay_time` datetime(6) NULL DEFAULT NULL,
  `is_pay` tinyint(1) NOT NULL,
  `food_amount` int(11) NOT NULL,
  `total_price` double NOT NULL,
  `table_id` int(11) NOT NULL,
  `comment` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `staff_id` int(11) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `OrderSystem_order_staff_id_beb837e5_fk_OrderSystem_staff_ID`(`staff_id`) USING BTREE,
  CONSTRAINT `OrderSystem_order_staff_id_beb837e5_fk_OrderSystem_staff_ID` FOREIGN KEY (`staff_id`) REFERENCES `ordersystem_staff` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordersystem_order
-- ----------------------------
INSERT INTO `ordersystem_order` VALUES (1, '2023-04-15 22:00:23.534294', '2023-04-15 22:00:31.948910', 1, 1, 15, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (2, '2023-04-15 22:01:59.315043', '2023-04-15 23:35:48.507053', 1, 2, 30, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (3, '2023-04-15 23:22:14.551756', '2023-04-15 23:35:48.542045', 1, 1, 15, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (4, '2023-04-15 23:22:59.108599', '2023-04-15 23:27:15.553449', 1, 1, 15, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (5, '2023-04-15 23:35:06.131233', '2023-04-15 23:35:48.574057', 1, 1, 15, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (6, '2023-04-15 23:38:49.807553', '2023-04-16 22:40:15.935141', 1, 1, 15, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (7, '2023-04-16 16:57:43.656927', '2023-04-16 16:57:46.541353', 1, 1, 15, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (8, '2023-04-16 21:31:04.472129', '2023-04-16 22:40:15.984110', 1, 2, 30, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (9, '2023-04-16 22:25:49.424887', '2023-04-16 22:26:04.098069', 1, 3, 45, 1, '', 1);
INSERT INTO `ordersystem_order` VALUES (10, '2023-04-16 22:39:57.941817', '2023-04-16 22:40:15.999100', 1, 4, 70, 1, '', 1);

-- ----------------------------
-- Table structure for ordersystem_orderitem
-- ----------------------------
DROP TABLE IF EXISTS `ordersystem_orderitem`;
CREATE TABLE `ordersystem_orderitem`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` int(11) NOT NULL,
  `sum_price` double NOT NULL,
  `status` int(11) NOT NULL,
  `start_cook_time` time(6) NULL DEFAULT NULL,
  `end_cook_time` time(6) NULL DEFAULT NULL,
  `comment` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `foodID_id` int(11) NOT NULL,
  `orderID_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `OrderSystem_orderitem_foodID_id_f4b872a6_fk_OrderSystem_food_ID`(`foodID_id`) USING BTREE,
  INDEX `OrderSystem_orderite_orderID_id_3bf8e07c_fk_OrderSyst`(`orderID_id`) USING BTREE,
  CONSTRAINT `OrderSystem_orderite_orderID_id_3bf8e07c_fk_OrderSyst` FOREIGN KEY (`orderID_id`) REFERENCES `ordersystem_order` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `OrderSystem_orderitem_foodID_id_f4b872a6_fk_OrderSystem_food_ID` FOREIGN KEY (`foodID_id`) REFERENCES `ordersystem_food` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordersystem_orderitem
-- ----------------------------
INSERT INTO `ordersystem_orderitem` VALUES (1, 1, 15, 0, NULL, NULL, '', 1, 1);
INSERT INTO `ordersystem_orderitem` VALUES (2, 2, 30, 3, '22:53:09.117772', '22:53:17.052002', '', 1, 2);
INSERT INTO `ordersystem_orderitem` VALUES (3, 1, 15, 0, NULL, NULL, '', 1, 3);
INSERT INTO `ordersystem_orderitem` VALUES (4, 1, 15, 0, NULL, NULL, '', 1, 4);
INSERT INTO `ordersystem_orderitem` VALUES (5, 1, 15, 0, NULL, NULL, '', 1, 5);
INSERT INTO `ordersystem_orderitem` VALUES (6, 1, 15, 3, '16:57:50.187934', '16:57:52.966851', '', 1, 6);
INSERT INTO `ordersystem_orderitem` VALUES (7, 1, 15, 0, NULL, NULL, '', 1, 7);
INSERT INTO `ordersystem_orderitem` VALUES (8, 2, 30, 3, '22:28:18.938501', '22:28:28.113143', '', 1, 8);
INSERT INTO `ordersystem_orderitem` VALUES (9, 3, 45, 0, NULL, NULL, '', 1, 9);
INSERT INTO `ordersystem_orderitem` VALUES (10, 2, 30, 0, NULL, NULL, '', 1, 10);
INSERT INTO `ordersystem_orderitem` VALUES (11, 2, 40, 0, NULL, NULL, '', 2, 10);

-- ----------------------------
-- Table structure for ordersystem_staff
-- ----------------------------
DROP TABLE IF EXISTS `ordersystem_staff`;
CREATE TABLE `ordersystem_staff`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `citizenID` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `gender` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `born_date` date NULL DEFAULT NULL,
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `address` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordersystem_staff
-- ----------------------------
INSERT INTO `ordersystem_staff` VALUES (1, 'dsafsadf', 'bhml', 'male', '2023-04-15', '110', '撒旦范德萨分');
INSERT INTO `ordersystem_staff` VALUES (2, 'dsafsadf', '高启强', 'male', '2023-04-15', '119', '旧厂街');
INSERT INTO `ordersystem_staff` VALUES (3, '50038325122', '高启盛', 'male', '2022-01-01', '125', '京海');

-- ----------------------------
-- Table structure for ordersystem_staff_table
-- ----------------------------
DROP TABLE IF EXISTS `ordersystem_staff_table`;
CREATE TABLE `ordersystem_staff_table`  (
  `ID` int(11) NOT NULL,
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `staff_id` int(11) NOT NULL,
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `OrderSystem_staff_ta_staff_id_b9c44bf4_fk_OrderSyst`(`staff_id`) USING BTREE,
  CONSTRAINT `OrderSystem_staff_ta_staff_id_b9c44bf4_fk_OrderSyst` FOREIGN KEY (`staff_id`) REFERENCES `ordersystem_staff` (`ID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of ordersystem_staff_table
-- ----------------------------
INSERT INTO `ordersystem_staff_table` VALUES (1, '一号桌', 1);
INSERT INTO `ordersystem_staff_table` VALUES (2, '二号桌', 1);
INSERT INTO `ordersystem_staff_table` VALUES (3, '三号桌', 2);

SET FOREIGN_KEY_CHECKS = 1;
