#!/usr/bin/python3
import sqlite3
import sys

if len(sys.argv) > 1:
    dbname = sys.argv[1];
    db = sqlite3.connect( dbname )
    cur = db.cursor();
    for row in cur.execute( 'SELECT network,password FROM networks ORDER BY network;'):
        print( 'network={')
        print( f'    ssid="{row[0]}"' )
        print( f'    psk="{row[1]}"\n' )
        print( '}\n');
