from app.services.firestore_service import FirestoreService

class UserProfileService:
    def __init__(self):
        self.firestore = FirestoreService

    def add_new_user(self, user_uid: str, ):
        self.firestore.add_doc('users', fields_dict={}, doc_id=user_uid)


