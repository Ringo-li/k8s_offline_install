from flask import Flask
import socket
import logging

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, world! i am ' + socket.gethostname() + ' version: 21.12.13.04'

@app.route('/hello/<username>')
def hello(username):
    return 'welcome' + ': ' + username + '!'