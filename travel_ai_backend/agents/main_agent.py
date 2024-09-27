from dotenv import load_dotenv
import os
import google.generativeai as genai
from transformers import AutoTokenizer


project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
env_path = os.path.join(project_root, 'config/.env')

load_dotenv(env_path)

google_api_key = os.getenv("GOOGLE_API_KEY")

class ChatBot:
    def __init__(self):
        genai.configure(api_key=google_api_key)
        self.model = genai.GenerativeModel('gemini-1.5-flash-latest')

    def send_Request(self, request):
        """

        :param request: user message
        :return: responce.text
        """
        response = self.model.generate_content(request)
        return response.text

    def count_tokens(text, model_name="gpt2"):
        tokenizer = AutoTokenizer.from_pretrained(model_name)
        return len(tokenizer.encode(text))
