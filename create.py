# This script creates an empty database as used by automorphic-website
# After creation it should be placed in a directory with the correct chmod

import os.path, sqlite3, sys

def execute(filename):
  query = open("database/" + filename, "r").read()
  cursor = connection.cursor()
  cursor.executescript(query)

tables = ["bibliography_items.sql",
          "bibliography_values.sql",
          "changes.sql",
          "citations.sql",
          "comments.sql",
          "commits.sql",
          "dependencies.sql",
          "macros.sql",
          "sections.sql",
          "statistics.sql",
          "tags.sql",
          "tags_search.sql",
          "graphs.sql",
          "slogans.sql"]
indices = "indices.sql"

if os.path.isfile("automorphic.sqlite"):
  print "The file automorphic.sqlite already exists in this folder, aborting"
  sys.exit()

print "Creating the database in automorphic.sqlite"

connection = sqlite3.connect("automorphic.sqlite")

map(execute, tables)
execute(indices)

connection.commit()
connection.close()

print "The database has been created"
