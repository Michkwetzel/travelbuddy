import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account.
cred = credentials.Certificate('/Users/michaelwetzel/travelai/keys/travelai-88a07-firebase-adminsdk-1gica-f571bc970b.json')
app = firebase_admin.initialize_app(cred)
db = firestore.client()

class FirestoreService():
    def addDoc(self, collection: str, uid: str, data: dict):
        """
        data = {"name": "Los Angeles", "state": "CA", "country": "USA"}

        # Add a new doc in collection 'cities' with ID 'LA'
        db.collection("cities").document("LA").set(data)

        :param collection:
        :param uid:
        :param data:
        :return:
        """

        doc_ref = db.collection(collection).document(uid)
        return doc_ref.set(data)

    def getMultipleDocs(self, collection: str, field: str, operator: str, value) -> list:
        """
        Retrieves multiple documents from Firestore based on a query filter.

        :param collection: The name of the collection.
        :param field: The field to filter on.
        :param operator: The comparison operator (e.g., "==", ">", "<", ">=", "<=").
        :param value: The value to compare against.
        :return: A list of document dictionaries.
        """

        docs = db.collection(collection).where(field, operator, value).stream()
        return [doc.to_dict() for doc in docs]

    def getDoc(self, collection: str, uid: str):
        '''


        :param collection:
        :param uid:
        :return:
        '''

        doc_ref = db.collection(collection).document(uid)

        doc = doc_ref.get()
        if doc.exists:
            print(f"Document data: {doc.to_dict()}")
            return doc.to_dict()
        else:
            print("No such document!")
            return []


    def deleteDoc(self, collection: str, uid: str):
        """
        db.collection("cities").document("DC").delete()

        :param collection:
        :param uid:
        :return:
        """

        db.collection(collection).document(uid).delete()

    def deleteFieldinDoc(self, collection: str, field: str, document_id: str) -> None:
        """
        Deletes a field from a document in Firestore.

        :param collection: The name of the collection.
        :param field: The name of the field to delete.
        :param document_id: The ID of the document to update.
        """
        doc_ref = db.collection(collection).document(document_id)
        field_delete = firestore.firestore.DELETE_FIELD  # Access DELETE_FIELD correctly
        doc_ref.update({field: field_delete})