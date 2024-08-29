from flask import Flask, request, jsonify
from flask_cors import CORS

import concurrent.futures
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
CORS(app)  # This will enable CORS for all routes

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


@app.route('/create_new_user_profile', methods=['POST'])
def create_new_user_profile():
    try:
        request_body = request.get_json()
        user_email = request_body.get('userEmail')
        user_id = request_body.get('userID')
        display_name = request_body.get('displayName')

        chat_id = firestore.add_new_user(user_uid=user_id, user_email=user_email, display_name=display_name)
        return jsonify({"chat_id": chat_id, "message": "User was added to database"})

    except Exception as e:
        return jsonify({f'status": "error", "message": "An error occurred {e}'})  # Internal Server Error


@app.route('/create_new_chatroom', methods=['POST'])
def create_new_chatroom():
    try:
        request_body = request.get_json()
        user_id = request_body.get('userID')

        chat_id = firestore.create_new_chatroom(user_id=user_id)
        return jsonify({"chat_id": chat_id, "message": "Chatroom was added to database"})

    except Exception as e:
        return jsonify({f'message": "An error occurred {e}'})  # Internal Server Error


@app.route('/receive_user_massage', methods=['POST'])
def receive_user_message():
    """
    Listens for user message and initiates LLM logic
    request body: userID, chatID, message, timestamp
    :return random message fow now
    """
    try:
        request_body = request.get_json()

        # Checks if all fields present
        #all_fields_present, missing_fields = check_required_fields(request_body, ['userID', 'chatID', 'message'])

        # if not all_fields_present:
        #     print("Error, Missing fields: " + missing_fields)
        #     return jsonify({"status": "error", "message": f'Missing fields: " + {missing_fields}'})

        user_id = request_body.get('userID')
        chat_id = request_body.get('chatID')
        message = request_body.get('message')
        timestamp = datetime.datetime.now()

        user_message_entry = {'message': message, 'role': 'user', 'timestamp': timestamp}

        # Save user message to cloud DB
        message_collection_path = f'users/{user_id}/chats/{chat_id}/messages'
        response = firestore.add_doc(doc_path=message_collection_path, fields_dict=user_message_entry)
        print(f'message recieved. path: {message_collection_path}, message_fields: {user_message_entry} doc_ID: {response}')

        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(firestore.update_chatroom_latest_timestamp, user_id=user_id, chat_id=chat_id, timestamp=timestamp)
            print(future.result())
            print(f'Latest chatroom timestamp updated: chatroom: {chat_id}, timestamp: {timestamp}')

        message += "**Note** Before this sentance is what the user requested. Note you are a travel agent so act in a travel agent way. expect the user to ask travel questions"

        llm_response = chat_bot.send_Request(message)
        timestamp = datetime.datetime.now()
        llm_message_entry = {
             'message': llm_response,
             'role': 'assistant',
             'timestamp': timestamp
        }
        print(llm_message_entry)

        # Save LLM response to cloud DB
        firestore.add_doc(doc_path=message_collection_path, fields_dict=llm_message_entry)
        return jsonify({"status": "success", "message": "Message added to database"})
    except Exception as e:
        print(f"Unexpected error: {e}")
        return jsonify({"status": "error", "message": "An unexpected error occurred. Please try again later."})


def check_required_fields(request_body, required_fields):
    missing_fields = []

    for field in required_fields:
        if field not in request_body:
            missing_fields.append(field)

    if missing_fields:
        return False, missing_fields  # Return False and a list of missing fields

    return True, None
