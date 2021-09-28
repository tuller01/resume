from flask import Flask
from flask import render_template
application = Flask(__name__)
# run the app.

@application.route("/")
def hello_world():
    return render_template('index.html')
	
	
if __name__ == "__main__":
    application.run()