USE mysql;
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('P@ssw0rd');
UPDATE user SET plugin='' WHERE User='root';
CREATE DATABASE filerun;
FLUSH PRIVILEGES;
COMMIT;
