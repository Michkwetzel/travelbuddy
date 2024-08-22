from services.firestore_service import FirestoreService

firestore = FirestoreService()

# Get user data from user UID.
uid = "yr2783ghfehide"

#print(firestore.get_doc("users", uid))

# add a user

#newUserUID = "TestNewRules"
#doc_id = firestore.add_doc("users", {'age': '33', 'last': 'Jell', 'destination': 'Sri Lanka', 'passport': 'south african', 'email': 'random@gmail.com', 'first': 'Ben', 'location': "new zealand"}, newUserUID)
#print(doc_id)

#print(firestore.get_doc(doc_path='users/6A1fdmwR5mKjrCEcQ7ZB/chats/Chat1/messages', doc_id='2024-07-31-10-49-50'))
print(firestore.add_doc(doc_path='users/6A1fdmwR5mKjrCEcQ7ZB/chats/Chat1/messages', doc_id='2024-07-31-10-49-55', fields_dict={'hi': 'hi'}))

firestore.add_doc(doc_path='users')

#firestore.get_message()