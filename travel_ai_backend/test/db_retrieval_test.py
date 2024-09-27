import vertexai
from vertexai.generative_models import GenerativeModel

# TODO(developer): Update project & location
vertexai.init(project='travelai-88a07', location='us-west3')

# using Vertex AI Model as tokenzier
model = GenerativeModel("gemini-1.5-flash")

prompt = "hello world"
response = model.count_tokens(prompt)
print(f"Prompt Token Count: {response.total_tokens}")
print(f"Prompt Character Count: {response.total_billable_characters}")

prompt = ["hello world", "what's the weather today"]
response = model.count_tokens(prompt)
print(f"Prompt Token Count: {response.total_tokens}")
print(f"Prompt Character Count: {response.total_billable_characters}")