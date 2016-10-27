CREATE TABLE "comments" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE ,
  "tag" VARCHAR NOT NULL,
  "author" VARCHAR,
  "site" VARCHAR,
  "date" DATETIME DEFAULT CURRENT_TIMESTAMP,
  "comment" TEXT,
  "email" VARCHAR
);
