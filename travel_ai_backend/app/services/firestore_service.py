import json
import firebase_admin
import time
import datetime
from firebase_admin import credentials, firestore
from google.cloud import secretmanager

def get_secret(secret_name):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/570991179221/secrets/firebase_API_key/versions/1"
    response = client.access_secret_version(name=name)
    return response.payload.data.decode('UTF-8')

API_KEY = get_secret("firebase_API_key")


# Firebase initialization
cred = credentials.Certificate(json.loads(API_KEY))
firebase_admin.initialize_app(cred)

class FirestoreService:
    def __init__(self):
        self.db = firestore.client()

    def add_new_user(self, user_uid: str, user_email, display_name, tt_member=False):

        if self.db.collection('new_tt_members').document(user_email).get().to_dict():
            # New Travel Tribe paying member. Add paid flag to dB
            print('Paying travel tribe member')
            tt_member = True

        timestamp = datetime.datetime.now()

        user_doc_ref = self.db.collection('users').document(user_uid)
        user_doc_ref.set({
            'display_name': display_name,
            'email': user_email,
            'tt_member': tt_member
        }, merge=True)  # Merge to avoid overwriting existing data

        chats_collection = user_doc_ref.collection('chats')
        chatroom_doc_ref = chats_collection.document()
        chatroom_doc_ref.set({
            'description': 'First chatroom!',
            'timestamp_created': timestamp,
            'timestamp_last_message': timestamp,
        })

        messages_collection = chatroom_doc_ref.collection('messages')
        message_doc_ref = messages_collection.document()
        message_doc_ref.set({
            'message': 'Hi and Welcome to Travel Buddy! Here you can ask away any question.'
                       'Go on, ask me any nagging travel question!',
            'role': 'assistant',
            'timestamp': timestamp
        })

        # Move user from new_tt_member to active_tt_member
        #TODO: Add user info like Date joined etc.
        if tt_member:
            self.db.collection('active_tt_members').document(user_email).set({'email': user_email, 'display_name': display_name})
            self.db.collection('new_tt_members').document(user_email).delete()

        return chatroom_doc_ref.id

    def create_new_chatroom(self, user_id: str):
        timestamp = datetime.datetime.now()

        chatroom_doc_ref = self.db.collection(f'users/{user_id}/chats').document()
        chatroom_doc_ref.set({
            'description': 'New chatroom',
            'timestamp_created': timestamp,
            'timestamp_last_message': timestamp
        }, merge=True)

        message_doc_ref = chatroom_doc_ref.collection('messages').document()
        message_doc_ref.set({
            'message' : 'Where are we traveling to today?',
            'role': 'assistant',
            'timestamp': timestamp
        }, merge=True)

        return chatroom_doc_ref.id

    def update_chatroom_latest_timestamp(self, user_id: str, chatroom_id: str, timestamp):
        doc_ref = self.db.collection(f'users/{user_id}/chats').document(chatroom_id)
        doc_ref.update({'timestamp_last_message': timestamp})
        print(f"Chatroom: users/{user_id}/chats/{doc_ref.id} updated with, timestamp_last_message': {timestamp}")
        return 'Success'

    def add_doc(self, doc_path: str, fields_dict: dict, doc_id = None) -> str:
        """
        Adds a document to the specified collection.
        If no doc_id given then google automatically assigns random
        :param doc_path:
        :param fields_dict:
        :param doc_id:
        :return: doc_id
        """
        if doc_id is None or doc_id == "":
            # for when you don't provide a doc id. google generates automatically
            update_time, doc_ref = self.db.collection(doc_path).add(fields_dict)
            return doc_ref.id
        else:
            self.db.collection(doc_path).document(doc_id).set(fields_dict)
            return doc_id


    def get_docs(self, doc_path: str, field: str = None, operator: str = None, value=None) -> list:
        """Gets documents, optionally filtered by field, operator, and value."""
        query = self.db.collection(doc_path)
        if field and operator and value:
            query = query.where(field, operator, value)
        return [doc.to_dict() for doc in query.stream()]

    def get_doc(self, doc_path: str, doc_id: str) -> dict:
        """Gets a single document by its ID."""

        #doc = self.db.document(f'{doc_path}/{doc_id}').get()
        doc = self.db.collection(doc_path).document(doc_id).get()

        return doc.to_dict() if doc.exists else {}

    def delete_doc(self, doc_path: str, doc_id: str) -> None:
        """Deletes a document by its ID."""
        print(f'doc_path: {doc_path}, doc_id: {doc_id}')
        doc_ref = self.db.collection(doc_path).document(doc_id)
        doc_ref.delete()

    def delete_collection(self, user_id: str, chatroom_id: str , batch_size: int = 300):
        message_path = f'users/{user_id}/chats/{chatroom_id}/messages'

        if batch_size == 0:
            return

        coll_ref = self.db.collection(message_path)
        docs = coll_ref.list_documents()
        deleted = 0
        self.db.collection(f'users/{user_id}/chats').document(chatroom_id).delete()

        for doc in docs:
            doc.delete()
            deleted = deleted + 1

        if deleted >= batch_size:
            self.delete_collection(message_path, chatroom_id, batch_size)


    def change_document_field(self, user_id: str, chatroom_id: str , field: str, value: str):

        doc_ref = self.db.collection(f'users/{user_id}/chats').document(chatroom_id)
        doc_ref.update({f'{field}': value})
        print(f"Chatroom: users/{user_id}/chats/{doc_ref.id} updated with, {field}': {value}")
        return 'Success'



    def delete_field(self, doc_path: str, doc_id: str, field: str) -> None:
        """Deletes a specific field from a document."""
        self.db.collection(doc_path).document(doc_id).update({field: firestore.firestore.DELETE_FIELD})

    def get_message(self):
        start_time = time.time()

        doc_ref = self.db.document('users/6A1fdmwR5mKjrCEcQ7ZB/chats/Chat1/messages/2024-07-31-10-49-50')
        doc = doc_ref.get()

        if doc.exists:
            message_data = doc.to_dict()
            print(message_data)
        else:
            print("Document not found")

        end_time = time.time()
        elapsed_time = end_time - start_time
        print(f"Get message Execution time: {elapsed_time} seconds")
