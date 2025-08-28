from flask import current_app as app, render_template

@app.route("/")
def hello_world():
    return render_template('index.html')