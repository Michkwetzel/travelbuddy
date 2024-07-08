import os
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI

load_dotenv('/Users/michaelwetzel/PycharmProjects/agent/config/.env')
openai_api_key = os.getenv("OPENAI_API_KEY")

llm = ChatOpenAI(api_key=openai_api_key)

llm.invoke("how can langsmith help with testing?")