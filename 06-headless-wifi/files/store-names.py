#!/usr/bin/python3
import sys
import sqlite3
dbname = ''
network = ''
password = ''
if len( sys.argv ) == 4:
    dbname = sys.argv[1]
    network = sys.argv[2]
    password = sys.argv[3]
elif len( sys.argv ) == 3:
    dbname =  '/var/web-networks/nets.db';
    network = sys.argv[1]
    password = sys.argv[2]

if len( sys.argv ) >= 3 and len( network ) > 0 :
    db = sqlite3.connect( dbname )
    cursor = db.cursor()
    cursor.execute( 'INSERT INTO networks (network, password) VALUES(?, ?)',
                    ( network, password ) )
    db.commit();
    
