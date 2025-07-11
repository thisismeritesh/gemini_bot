from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import google.generativeai as genai
import os

# Load .env file
load_dotenv()

# Tell dotenv to look in the parent directory
load_dotenv(dotenv_path=os.path.join(os.path.dirname(__file__), '..', '.env'))

api_key = os.getenv("GEMINI_API_KEY")
print("Loaded API key:", api_key) 
# Get key from environment
api_key = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=api_key)  # ✅ Use the variable here


model = genai.GenerativeModel("gemini-1.5-flash")

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PromptRequest(BaseModel):
    prompt: str
    max_length: int = 100

@app.post("/generate")
async def generate_text(req: PromptRequest):
    if not req.prompt.strip():
        return {"response": "Prompt cannot be empty."}
    try:
        response = model.generate_content(req.prompt)
        return {"response": response.text}
    except Exception as e:
        return {"response": f"❌ Error: {str(e)}"}
