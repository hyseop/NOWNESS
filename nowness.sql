CREATE TABLE IF NOT EXISTS `users` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`email`	VARCHAR(255) UNIQUE	NOT NULL,
	`password` VARCHAR(255) NOT NULL,
	`last_password_changed`	DATETIME DEFAULT now(),
	`nickname` VARCHAR(255) UNIQUE NOT NULL,
	`created` DATETIME DEFAULT now(),
	`admin`	BOOLEAN DEFAULT FALSE,
	`last_updated_ip` VARCHAR(255) NOT NULL,
    `verified` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `blacklist` (
	`user_id` INT NOT NULL,
	`ban_datetime` DATETIME DEFAULT now(),
	`ban_reason` VARCHAR(255) NOT NULL,
    PRIMARY KEY(user_id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `boardtypes` (
	`id` INT UNIQUE NOT NULL,
	`type_name` VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS `locales` (
	`id` INT UNIQUE NOT NULL,
	`locale_name` VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS `subcategories` (
	`id` INT UNIQUE NOT NULL,
	`category_name` VARCHAR(255) UNIQUE NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS `contents` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`user_id` INT NULL,
	`created_datetime` DATETIME DEFAULT	now(),
	`edit_datetime`	DATETIME DEFAULT now(),
	`views`	INT DEFAULT 0,
	`contents` TEXT NOT NULL,
	`title`	VARCHAR(255) NOT NULL,
	`blind`	BOOLEAN DEFAULT 0,
	`deleted` BOOLEAN DEFAULT 0,
	`board_type` INT NOT NULL,
	`locale` INT NOT NULL,
	`subcategory` INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY(board_type) REFERENCES boardtypes(id) ON UPDATE CASCADE,
    FOREIGN KEY(locale) REFERENCES locales(id) ON UPDATE CASCADE,
    FOREIGN KEY(subcategory) REFERENCES subcategories(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `replies` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`contents_id` INT NOT NULL,
	`user_id` INT NULL,
	`reply` TEXT NOT NULL,
	`created_datetime`	DATETIME DEFAULT now(),
	`deleted` BOOLEAN DEFAULT FALSE,
	`parent_id`	INT DEFAULT NULL,
    PRIMARY KEY(id, contents_id),
    FOREIGN KEY(contents_id) REFERENCES contents(id) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY(parent_id) REFERENCES replies(id)
);

CREATE TABLE IF NOT EXISTS `files` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`contents_id` INT NOT NULL,
	`orgin_name` VARCHAR(255) NOT NULL,
	`save_name`	VARCHAR(255) NOT NULL,
	`path`	TEXT NOT NULL,
	`size`	INT NOT NULL,
	`ext`	VARCHAR(5) NOT NULL,
    PRIMARY KEY(id, contents_id),
    FOREIGN KEY(contents_id) REFERENCES contents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `tags` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`contents_id` INT NOT NULL,
	`tag` VARCHAR(255) NOT NULL,
    PRIMARY KEY(id, contents_id),
    FOREIGN KEY(contents_id) REFERENCES contents(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `likes` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`contents_id` INT NOT NULL,
	`user_id` INT NOT NULL,
	`like_datetime`	DATETIME DEFAULT now(),
    PRIMARY KEY(id, contents_id),
    FOREIGN KEY(contents_id) REFERENCES contents(id) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS `reports` (
	`id` INT NOT NULL AUTO_INCREMENT,
	`reported_contents_id` INT NOT NULL,
	`report_user_id` INT NOT NULL,
	`report_reason` VARCHAR(255) NOT NULL,
	`report_datetime` DATETIME DEFAULT now(),
    PRIMARY KEY(id),
    FOREIGN KEY(reported_contents_id) REFERENCES contents(id),
    FOREIGN KEY(report_user_id) REFERENCES users(id)
);

-- 이메일 인증

CREATE TABLE IF NOT EXISTS `unverified_emails` (
	`code` CHAR(36) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`code`)
);

DELIMITER //
CREATE PROCEDURE verify_email(IN code CHAR(36), OUT deletedRows INT)
BEGIN
	SET @email = '';
    SELECT email INTO @email FROM Unverified_emails WHERE Unverified_emails.code = code;
	UPDATE Users SET verified = TRUE WHERE Users.email = @email;
    DELETE FROM Unverified_emails WHERE Unverified_emails.code = code;
    SET deletedRows = ROW_COUNT();
    DELETE FROM Unverified_emails WHERE Unverified_emails.email = @email;
END //
DELIMITER ;

-- 비밀번호 재설정

CREATE TABLE IF NOT EXISTS `password_reset_lists` (
	`code` CHAR(36) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `date` date DEFAULT (CURDATE()), -- CURRENT_DATE 사용해도 됨
    PRIMARY KEY (`code`)
);

DROP EVENT IF EXISTS delete_expired_password_reset_data;

CREATE EVENT delete_expired_password_reset_data
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
  DELETE FROM password_reset_lists
  WHERE date < DATE_SUB(NOW(), INTERVAL 3 DAY);
  
DELIMITER //
CREATE PROCEDURE reset_password(IN code CHAR(36), IN newPassword VARCHAR(255), OUT updatedRows INT)
BEGIN
	SET @email = '';
    SELECT email INTO @email FROM password_reset_lists WHERE password_reset_lists.code = code;
	UPDATE Users SET users.password = newPassword WHERE Users.email = @email;
    SET updatedRows = ROW_COUNT();
    DELETE FROM password_reset_lists WHERE password_reset_lists.email = @email;
END //
DELIMITER ;