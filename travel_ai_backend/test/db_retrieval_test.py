from test.firestore_service import FirestoreService

firestore = FirestoreService()

# Get user data from user UID.
uid = "yr2783ghfehide"

#print(firestore.get_doc("users", uid))

# add a user

newUserUID = "ExNgWo4XnoRpMjflGJtHix83Td6W2"
print(firestore.add_doc("users", newUserUID, {'age': '30', 'last': 'Jell', 'destination': 'Sri Lanka', 'passport': 'south african', 'email': 'random@gmail.com', 'first': 'Ben', 'location': "new zealand"}))

