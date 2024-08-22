import json
from flask_server_code import app

from services.firestore_service import FirestoreService

firestore = FirestoreService()

firestore.add_new_user('12123', 'qwert@gmail.com', 'michael')

#
# # Create a test client
# with app.test_client() as client:
#     # Prepare your test data
#     testData = {
#         'userID': '6A1fdmwR5mKjrCEcQ7ZB',
#         'chatID': 'Chat1',
#         'message': 'Hello, LLM!',
#         'timestamp': '2024-08-05T11:22:00'
#     }
#
#     # Send a POST request to your route
#     response = client.post('/receive_user_massage', data=json.dumps(testData), content_type='application/json')
#
#     # Assert the response status code and content
#     assert response.status_code == 200
#     print(response.get_data())
#
