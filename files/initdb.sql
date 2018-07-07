USE mysql;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('P@ssw0rd');
UPDATE user SET plugin='' WHERE User='root';
FLUSH PRIVILEGES;
CREATE DATABASE filerun;
COMMIT;
