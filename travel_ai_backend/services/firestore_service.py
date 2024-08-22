import firebase_admin
import time
import datetime
from firebase_admin import credentials, firestore


# Firebase initialization (ideally, do this once in your app's entry point)
cred = credentials.Certificate(
    '/Users/michaelwetzel/travelbuddy/keys/travelai-88a07-firebase-adminsdk-1gica-f571bc970b.json')  # Replace with your path
firebase_admin.initialize_app(cred)


class FirestoreService:
    def __init__(self):
        self.db = firestore.client()

    def add_new_user(self, user_uid: str, user_email, display_name, tt_member=False):

        if self.db.collection('new_tt_members').document(user_email).get().to_dict():
            # New Travel Tribe paying member. Add paid flag to dB
            print('Paying travel tribe member')
            tt_member = True

        user_doc_ref = self.db.collection('users').document(user_uid)
        user_doc_ref.set({
            'display_name': display_name,
            'email': user_email,
            'tt_member': tt_member
        }, merge=True)  # Merge to avoid overwriting existing data

        chats_collection = user_doc_ref.collection('chats')
        chatroom_doc_ref = chats_collection.document('1')
        chatroom_doc_ref.set({
            'description': 'First chatroom!'
        })

        messages_collection = chatroom_doc_ref.collection('messages')
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
        message_doc_ref = messages_collection.document(timestamp)
        message_doc_ref.set({
            'message': 'Hi and Welcome to Travel Buddy! Here you can ask away any question.'
                       'Go on, ask me any nagging travel question!',
            'role': 'assistant'
        })

        # Move user from new_tt_member to active_tt_member
        #TODO: Add user info like Date joined etc.
        if tt_member:
            self.db.collection('active_tt_members').document(user_email).set({'email': user_email, 'display_name': display_name})
            self.db.collection('new_tt_members').document(user_email).delete()


    def add_doc(self, doc_path: str, fields_dict: dict, doc_id: str = None) -> str:
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
        self.db.collection(doc_path).document(doc_id).delete()

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
