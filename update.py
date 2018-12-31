import bibliography.update, historical.data, statistics.commits, statistics.counts, tags.tags, tags.tex, tags.titles

print "Taking care of the bootstrap"
tags.tags.importBootstrap()
print "Importing tags"
tags.tags.importTags()
print "Cleaning removed tags"
tags.tags.checkTags()

print "\nClearing search table"
tags.tex.clearSearchTable()
print "\nImporting LaTeX code"
tags.tex.importLaTeX()

print "\nUpdating the line counts"
statistics.counts.updateLineCounts()
print "Updating the page counts"
statistics.counts.updatePageCounts()

#RESTORE STATISTICS WHEN READY
#print "\nUpdating commit information"
#statistics.commits.updateCommits()
print "\nImporting titles"
tags.titles.importTitles()

print "\nClearing bibliography"
bibliography.update.clearBibliography()
print "Importing bibliography"
bibliography.update.importBibliography()


