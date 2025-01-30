
from flask import Blueprint, jsonify
from models import Example

main = Blueprint('main', __name__)

@main.route('/')
def home():
    return jsonify(message="Welcome to the Dockerized Flask App with PostgreSQL!")

@main.route('/data')
def data():
    examples = Example.query.all()
    return jsonify(data=[example.to_dict() for example in examples])
