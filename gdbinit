set height 0
set print pretty on
set pagination off

set debug-file-directory /usr/lib/debug

set history filename /usr/home/markj/.gdb_history
set history save on
set history size 65536

# Make it easy to source scripts.
directory /usr/home/markj/bin/scripts/kgdb
python sys.path.append("/usr/home/markj/bin/scripts/kgdb")
