from flask import Flask
from flask import render_template
import socket
from datetime import datetime
import logging
import os
import sys
import requests
import random

app_version = "0.0.2"
hostname = socket.gethostname()
ip = socket.gethostbyname(hostname)
datetime = datetime.now().replace(microsecond=0).isoformat()
products = ['Kubernetes Engine',
            'Anthos',
            'Cloud Build',
            'Cloud Functions',
            'Cloud Logging',
            'Cloud Monitoring',
            'Compute Engine',
            'BigQuery']

app = Flask(__name__)
alpha_enabled = os.environ.get('ENABLE_ALPHA')

def get_product():
    return(random.choice(products))

product = get_product()

@app.route("/")
def hello():
    return render_template('index.html',
                            product=product,
                            hostname=hostname,
                            ip=ip,
                            datetime=datetime,
                            app_version=app_version,
                            alpha_enabled=alpha_enabled)

# if __name__ == "__main__":
#     app.run(host='0.0.0.0', debug=False)