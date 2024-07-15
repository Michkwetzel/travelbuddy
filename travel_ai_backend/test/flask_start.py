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

@app.route('/get_db_doc', methods=['POST'])
def get_db_doc():
    request_body = request.get_json()
    print(request_body)
    doc_id = request_body.get('doc_id')
    collection = request_body.get('collection')
    print(doc_id)
    if doc_id:
        doc = firestore.get_doc(collection, doc_id)
        print(doc)
        return jsonify(doc)
    else:
        return jsonify({"message": "collection or data is null"})


@app.route('/write_to_db', methods=['POST'])
def write_to_db():
    try:
        request_body = request.get_json()
        print(request_body)
        collection = request_body.get('collection')
        data = request_body.get('data')
        doc_id = request_body.get('doc_id')

        if collection is None or data is None:
            return jsonify({"message": "collection or data is null"})
        else:
            return firestore.add_doc(collection, data, doc_id)

    except Exception as e:  # Catch-all for other errors
        return jsonify({"status": "error", "message": "An error occurred"}), 500  # Internal Server Error