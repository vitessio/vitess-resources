# Test data

Test data for Vitess tests and benchmarks.

## `enwiki-20080103-pages-articles.ibd.tar.zst`

This Zstd archive is used in Vitess `mysqlctl` compression benchmarks:

```sh
vitessio/vitess $ go test -bench=BenchmarkCompress ./go/vt/mysqlctl -run=NONE -timeout=12h
BenchmarkCompressLz4Builtin-8        1     59562955167 ns/op   1121.27 MB/s    3.101 compression-ratio/op
BenchmarkCompressPargzipBuiltin-8    1    207188453500 ns/op    322.34 MB/s    2.937 compression-ratio/op
...
```

The archive is built from a subset of [this Wikipedia XML archive](https://dumps.wikimedia.org/archive/enwiki/20080103/enwiki-20080103-pages-articles.xml.bz2).

It is not included in this GitHub repository because it is too large. Instead, it is built locally and then attached to a GitHub release.

To build the archive locally:

 1. Download and compile the `xml2sql` tool:
    ```
    $ git clone https://github.com/Tietew/mediawiki-xml2sql
    $ cd mediawiki-xml2sql
    mediawiki-xml2sql $ ./configure && make
    $ cd ..
    ```
 1. Download the Wikipedia XML data set:
    ```sh
    $ wget https://dumps.wikimedia.org/archive/enwiki/20080103/enwiki-20080103-pages-articles.xml.bz2
    ```
 1. Convert the Wikipedia XML data set to MySQL `INSERT` statements:
    ```
    $ bunzip2 -c enwiki-20080103-pages-articles.xml.bz2 | ./mediawiki-xml2sql/xml2sql -m
    ```
 1. Reduce the size of `text.sql` to 2GiB:
    ```sh
    $ truncate --no-create --size=2147483648 ./text.sql
    ```
 1. Prepare a MySQL 8.0 database and tables:
    ```sh
    $ cat << EOF | mysql -u root
    CREATE DATABASE enwiki;
    USE enwiki;

    CREATE TABLE `page` (
      `page_id` int unsigned NOT NULL AUTO_INCREMENT,
      `page_namespace` int NOT NULL,
      `page_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
      `page_restrictions` tinyblob NOT NULL,
      `page_counter` bigint unsigned NOT NULL DEFAULT '0',
      `page_is_redirect` tinyint unsigned NOT NULL DEFAULT '0',
      `page_is_new` tinyint unsigned NOT NULL DEFAULT '0',
      `page_random` double unsigned NOT NULL,
      `page_touched` binary(14) NOT NULL DEFAULT '\0\0\0\0\0\0\0\0\0\0\0\0\0\0',
      `page_latest` int unsigned NOT NULL,
      `page_len` int unsigned NOT NULL,
      PRIMARY KEY (`page_id`),
      UNIQUE KEY `name_title` (`page_namespace`,`page_title`),
      KEY `page_random` (`page_random`),
      KEY `page_len` (`page_len`)
    ) ENGINE=InnoDB AUTO_INCREMENT=15071264 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

    CREATE TABLE `revision` (
      `rev_id` int unsigned NOT NULL AUTO_INCREMENT,
      `rev_page` int unsigned NOT NULL,
      `rev_text_id` int unsigned NOT NULL,
      `rev_comment` mediumblob NOT NULL,
      `rev_user` int unsigned NOT NULL DEFAULT '0',
      `rev_user_text` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
      `rev_timestamp` char(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL DEFAULT '',
      `rev_minor_edit` tinyint unsigned NOT NULL DEFAULT '0',
      `rev_deleted` tinyint unsigned NOT NULL DEFAULT '0',
      PRIMARY KEY (`rev_page`,`rev_id`),
      UNIQUE KEY `rev_id` (`rev_id`),
      KEY `rev_timestamp` (`rev_timestamp`),
      KEY `page_timestamp` (`rev_page`,`rev_timestamp`),
      KEY `user_timestamp` (`rev_user`,`rev_timestamp`),
      KEY `usertext_timestamp` (`rev_user_text`,`rev_timestamp`)
    ) ENGINE=InnoDB AUTO_INCREMENT=182440736 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

    CREATE TABLE `text` (
      `old_id` int unsigned NOT NULL AUTO_INCREMENT,
      `old_text` mediumblob NOT NULL,
      `old_flags` tinyblob NOT NULL,
      PRIMARY KEY (`old_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=182440736 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci MAX_ROWS=10000000 AVG_ROW_LENGTH=10240;
    ```
 1. Load the SQL files into the database:
    ```sh
    $ cat *.sql | mysql -u root enwiki
    # The last insert statement may fail because of the truncate. That's OK.
    ```

 1. Create a tar file from the database InnoDB contents.
    ```sh
    $ mkdir enwiki-20080103-pages-articles
    $ MYSQL_DATADIR="$(mysql -u root -sNe 'select @@datadir')"
    $ cp ${MYSQL_DATADIR}/enwiki/*.ibd enwiki-20080103-pages-articles
    $ tar -c - enwiki-20080103-pages-articles | zstd -19 -o enwiki-20080103-pages-articles.ibd.tar.zst
    ```
