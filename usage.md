A simple tool to rename files randomly while saving a mapping to their old 
names.

Usage
=====

`blind [<directory>] [--dry-run]`

directory     The directory for which to rename all files. A file called 
              `unblind.csv` will be added to the directory to record how the
              names have been changed.

--dry-run     Don't rename any files, just print which files would be renamed 
              and an example of what they would be renamed to.

-h/--help     Print this help message.
