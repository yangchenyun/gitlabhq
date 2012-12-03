# Databases:

GitLab use MySQL as default database but you are free to use PostgreSQL.


## MySQL

    sudo apt-get install -y mysql-server mysql-client libmysqlclient-dev

    # Login to MySQL
    $ mysql -u root -p

    # Create the GitLab production database
    mysql> CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

    # Create the MySQL User change $password to a real password
    mysql> CREATE USER 'gitlab'@'localhost' IDENTIFIED BY '$password';

    # Grant proper permissions to the MySQL User
    mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost';


## PostgreSQL

    sudo apt-get install -y postgresql-9.1 postgresql-server-dev-9.1

    # Connect to database server
    sudo -u postgres psql -d template1

    # Add a user called gitlab. Change $password to a real password
    template1=# CREATE USER gitlab WITH PASSWORD '$password';

    # Create the GitLab production database & grant all privileges on database
    template1=# CREATE DATABASE gitlabhq_production OWNER gitlab;

    # Quit from PostgreSQL server
    template1=# \q

    # Try connect to new database
    sudo -u gitlab psql -d gitlabhq_production



#### Select the database you want to use

    # Mysql
    sudo -u gitlab cp config/database.yml.mysql config/database.yml

    # PostgreSQL
    sudo -u gitlab cp config/database.yml.postgresql config/database.yml

    # make sure to update username/password in config/database.yml

#### Install gems 

    # mysql
    sudo -u gitlab -H bundle install --without development test postgres  --deployment

    # or postgres
    sudo -u gitlab -H bundle install --without development test mysql --deployment
