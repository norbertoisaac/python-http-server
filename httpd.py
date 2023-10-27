#! /usr//bin/python3
import http.server
import socket

def usage():
  print('''
	--pid /path/to/pid/archive
	''')

class localHttpServerIPv6(http.server.ThreadingHTTPServer):
    address_family = socket.AF_INET6

class httpServerHandler( http.server.BaseHTTPRequestHandler):
    def __init__(self, request, client_address, server):
        super().__init__(request, client_address, server)

    def send_error(self, code, message=None, explain=None):
        message='Server Error'
        explain='sin mas explicaciones'
        self.server_version = "CentralApi/1"
        self.sys_version = "app/1"
        self.error_message_format = 'Internal server error'
        super(httpServerHandler, self).send_error( code, message, explain)


    def sendResponseBody(self, r):
        self.server_version = "CentralApi/1"
        self.sys_version = "app/1"
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(r)

    def do_GET(self):
        # If someone went to "http://something.somewhere.net/foo/bar/",
        # then s.path equals "/foo/bar/".
        import time
        print('llego un GET'+time.ctime())
        time.sleep(5)
        body = "<p>You accessed path: %s</p>" % self.path
        self.sendResponseBody(body.encode())

    #def do_POST(self):
    #    None

    #def do_PUT(self):
    #    None

import os
import sys
lastArg=''
for arg in sys.argv:
    if arg=='--help':
      usage()
      quit()	
    if lastArg=='--pid' and os.path.exists(arg):
        pid=os.getpid()
        f=open(arg,'w')
        f.write(str(pid))
        f.close()
    lastArg = arg
###############
# Un solo hilo
#httpServer = http.server.HTTPServer(('127.0.0.1',8000), httpServerHandler)
# Multi hilo
httpServer = localHttpServerIPv6(('::',8000), httpServerHandler)
###############
httpServer.serve_forever()
