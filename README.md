blind
=====

A simple tool to rename files randomly while saving a mapping to their old 
names.

Install
-------

```
git clone https://github.com/dp28/blind
cd blind
./install
```

Usage
-----

  `blind [<directory>] [--dry-run]`

* `directory`      The directory for which to rename all files. A file called 
                   `unblind.csv` will be added to the directory to record how 
                   the names have been changed.

* `--dry-run`      Don't rename any files, just print which files would be  
                   renamed and an example of what they would be renamed to.

* `-h` / `--help`  Print this help message.

Tests
-----

This project uses [RSpec](http://rspec.info/). To run the tests, run 
`bundle install` to install RSpec, then run 

  `bundle exec rspec`

During development, running 

  `bundle exec guard`

is recommended as it will run the corresponding tests to any file that is 
changed. In addition, it will run [rubocop](https://github.com/bbatsov/rubocop)
on each file to ensure it follows a consistent style guide.

License
-------

[MIT](./LICENSE)
