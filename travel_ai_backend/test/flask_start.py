from flask import Flask, request, jsonify
import sys
import os

#to get relative paths.
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
sys.path.append(parent_dir)

from services.firestore_service import FirestoreService

firestore = FirestoreService()
app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>How does this even work?</p>"

@app.route('/add_new_user', methods=['POST'])
def register_user():
    user_data = request.get_json()  # Get JSON data from the request
    # ... (Process user_data, store in database, etc.)
    print(user_data)

    return jsonify({"message": "User registered successfully"})

@app.route('/get_user_data', methods=['POST'])
def get_user_data():
    request_body = request.get_json()
    print(request_body)
    user_id = request_body.get('user_uid')
    print(user_id)
    if user_id:
        user_data = firestore.get_doc('users', user_id)
        print(user_data)
        return jsonify(user_data)
    else:
        return jsonify({"message": "Wrong UID"})