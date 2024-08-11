from flask import Flask, request, jsonify
import sys
import os
import datetime

#to get relative paths.
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
sys.path.append(parent_dir)

from services.firestore_service import FirestoreService
from agents.main_agent import ChatBot

firestore = FirestoreService()
chat_bot = ChatBot()
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
        return jsonify({"status": "error", "message": "An error occurred"})  # Internal Server Error

@app.route('/receive_user_massage', methods=['POST'])
def receive_user_message():
    """
    Listens for user message and initiates LLM logic
    request body: userID, chatID, message, timestamp
    :return status code
    """
    request_body = request.get_json()

    # Checks if all fields present
    all_fields_present, missing_fields = check_required_fields(request_body, ['userID', 'chatID', 'message', 'timestamp'])

    if not all_fields_present:
        print("Error, Missing fields: " + missing_fields)
        return jsonify({"status": "error", "message": f'Missing fields: " + {missing_fields}'})

    userID = request_body.get('userID')
    chatID = request_body.get('chatID')
    message = request_body.get('message')
    timestamp = request_body.get('timestamp')

    user_message_entry = {'message': message, 'role': 'user'}

    # Save user message to cloud DB
    message_collection_path = f'users/{userID}/chats/{chatID}/messages'
    response = firestore.add_doc(doc_path=message_collection_path, doc_id=timestamp, fields_dict=user_message_entry)

    llm_response = chat_bot.send_Request(message)
    llm_message_entry = {
         'message': llm_response,
         'role': 'assistant'
    }
    print(llm_message_entry)

    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
    # Save LLM response to cloud DB
    firestore.add_doc(doc_path=message_collection_path, doc_id=timestamp, fields_dict=llm_message_entry)
    return "Hi"


def check_required_fields(request_body, required_fields):
    missing_fields = []

    for field in required_fields:
        if field not in request_body:
            missing_fields.append(field)

    if missing_fields:
        return False, missing_fields  # Return False and a list of missing fields

    return True, None
