import firebase_admin
from firebase_admin import credentials, firestore

# Firebase initialization (ideally, do this once in your app's entry point)
cred = credentials.Certificate(
    '/Users/michaelwetzel/travelai/keys/travelai-88a07-firebase-adminsdk-1gica-f571bc970b.json')  # Replace with your path
firebase_admin.initialize_app(cred)


class FirestoreService:
    def __init__(self):
        self.db = firestore.client()

    def add_doc(self, collection: str, data: dict, doc_id: str = None) -> str:
        """
        Adds a document to the specified collection.
        If no doc_id given then google automatically assigns random
        :param collection:
        :param data:
        :param doc_id:
        :return: doc_id
        """
        if doc_id is None or doc_id == "":
            # for when you don't provide a doc id. google generates automatically
            update_time, doc_ref = self.db.collection(collection).add(data)
            return doc_ref.id
        else:
            self.db.collection(collection).document(doc_id).set(data)
            return doc_id


    def get_docs(self, collection: str, field: str = None, operator: str = None, value=None) -> list:
        """Gets documents, optionally filtered by field, operator, and value."""
        query = self.db.collection(collection)
        if field and operator and value:
            query = query.where(field, operator, value)
        return [doc.to_dict() for doc in query.stream()]

    def get_doc(self, collection: str, doc_id: str) -> dict:
        """Gets a single document by its ID."""
        doc = self.db.collection(collection).document(doc_id).get()
        return doc.to_dict() if doc.exists else {}

    def delete_doc(self, collection: str, doc_id: str) -> None:
        """Deletes a document by its ID."""
        self.db.collection(collection).document(doc_id).delete()

    def delete_field(self, collection: str, doc_id: str, field: str) -> None:
        """Deletes a specific field from a document."""
        self.db.collection(collection).document(doc_id).update({field: firestore.firestore.DELETE_FIELD})