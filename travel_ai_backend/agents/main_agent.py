from dotenv import load_dotenv
import os
import google.generativeai as genai

load_dotenv('/Users/michaelwetzel/TravelAgent/config/.env')

google_api_key = os.getenv("GOOGLE_API_KEY")

genai.configure(api_key=google_api_key)
model = genai.GenerativeModel('gemini-1.5-flash')



response = model.generate_content("I want to travel to Germany give me some tips")

print(response.text)