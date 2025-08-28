from flask import Blueprint, render_template, request
import sqlite3

main = Blueprint('main', __name__)

@main.route("/")
def hello_world():
    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute("SELECT name, message, timestamp FROM messages ORDER BY timestamp DESC")
    messages = c.fetchall()
    conn.close()
    return render_template('index.html', messages=messages)

@main.route("/contact", methods=["POST"])
def contact():
    name = request.form.get("name")
    email = request.form.get("email")
    message = request.form.get("message")

    conn = sqlite3.connect('database.db')
    c = conn.cursor()
    c.execute("INSERT INTO messages (name, email, message) VALUES (?, ?, ?)", (name, email, message))
    conn.commit()
    conn.close()

    return "Thank you for your message!"