#!/usr/bin/python3
import sys
import sqlite3

if len( sys.argv ) == 3:
    db = sqlite3.connect( '/var/web-networks/nets.db' )
    cursor = db.cursor()
    cursor.execute( 'INSERT INTO networks (network, password) VALUES(?, ?)',
                    (sys.argv[1], sys.argv[2]) )
    db.commit();
    
