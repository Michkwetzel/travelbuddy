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

@app.route('/create_new_user_profile', methods=['POST'])
def create_new_user_profile():
    try:
        request_body = request.get_json()
        user_email = request_body.get('userEmail')
        user_id = request_body.get('userID')
        display_name = request_body.get('displayName')

        chatroom_id = firestore.add_new_user(user_uid=user_id, user_email=user_email, display_name=display_name)
        return jsonify({"chatroom_id": chatroom_id, "message": "User was added to database"})

    except Exception as e:
        return jsonify({'status': 'error', 'message': f'An error occurred {e}', 'route': '/create_new_user_profile'})  # Internal Server Error

@app.route('/delete_chatroom', methods= ['POST'])
def delete_chatroom():
    try:
        request_body = request.get_json()
        user_id = request_body.get('userID')
        chatroom_id = request_body.get('chatroomID')

        firestore.delete_collection(user_id=user_id, chatroom_id=chatroom_id)
        return jsonify({'message': f'Chatroom {chatroom_id}, was deleted from database'})

    except Exception as e:
        return jsonify({'message': f'An error occurred {e}', 'route': '/delete_chatroom'})  # Internal Server Error

@app.route('/edit_chatroom_description', methods=['POST'])
def edit_chatroom_description():
    try:
        request_body = request.get_json()
        user_id = request_body.get('userID')
        chatroom_id = request_body.get('chatroomID')
        new_name = request_body.get('newDescription')

        result = firestore.change_document_field(user_id=user_id,chatroom_id=chatroom_id, field='description', value=new_name)
        return result

    except Exception as e:
        return jsonify({'message': f'An error occurred {e}', 'route': '/edit_chatroom_description'})  # Internal Server Error



@app.route('/create_new_chatroom', methods=['POST'])
def create_new_chatroom():
    try:
        request_body = request.get_json()
        user_id = request_body.get('userID')

        chatroom_id = firestore.create_new_chatroom(user_id=user_id)
        return jsonify({"chatroom_id": chatroom_id, "message": "Chatroom was added to database"})

    except Exception as e:
        return jsonify({'message': f'An error occurred {e}', 'route': '/create_new_chatroom'})


@app.route('/receive_user_massage', methods=['POST'])
def receive_user_message():
    """
    Listens for user message and initiates LLM logic
    request body: userID, chatID, message, timestamp
    :return random message fow now
    """
    try:
        request_body = request.get_json()

        user_id = request_body.get('userID')
        chatroom_id = request_body.get('chatroomID')
        message = request_body.get('message')
        timestamp = datetime.datetime.now()

        user_message_entry = {'message': message, 'role': 'user', 'timestamp': timestamp}

        # Save user message to cloud DB
        message_collection_path = f'users/{user_id}/chats/{chatroom_id}/messages'
        response = firestore.add_doc(doc_path=message_collection_path, fields_dict=user_message_entry)
        print(f'message recieved. path: {message_collection_path}, message_fields: {user_message_entry} doc_ID: {response}')

        firestore.update_chatroom_latest_timestamp(user_id=user_id, chatroom_id=chatroom_id, timestamp=timestamp)

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
        return jsonify({'message': f'An error occurred {e}', 'route': '/receive_user_message'})


def check_required_fields(request_body, required_fields):
    missing_fields = []

    for field in required_fields:
        if field not in request_body:
            missing_fields.append(field)

    if missing_fields:
        return False, missing_fields  # Return False and a list of missing fields

    return True, None
