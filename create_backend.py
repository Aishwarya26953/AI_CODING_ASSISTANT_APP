import os

# Base folder
base_dir = "backend"
app_dir = os.path.join(base_dir, "app")

# Create directories
os.makedirs(app_dir, exist_ok=True)

# Files with their content
files_content = {
    os.path.join(app_dir, "__init__.py"): "# Empty init file",
    
    os.path.join(app_dir, "main.py"): """from fastapi import FastAPI
from app import ai_routes, conversation_routes, snippet_routes

app = FastAPI(title="AI Coding Assistant Backend")

app.include_router(ai_routes.router, prefix="/ai", tags=["AI"])
app.include_router(conversation_routes.router, prefix="/conversation", tags=["Conversation"])
app.include_router(snippet_routes.router, prefix="/snippet", tags=["Snippet"])

@app.get("/")
async def root():
    return {"message": "🚀 AI Coding Assistant Backend is running!"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="127.0.0.1", port=8000, reload=True)
""",

    os.path.join(app_dir, "ai_routes.py"): """from fastapi import APIRouter
from app.schemas import ChatRequest, ChatResponse
from app.services import get_llm_response

router = APIRouter()

@router.post("/chat", response_model=ChatResponse)
async def chat_endpoint(request: ChatRequest):
    response = get_llm_response(request.prompt)
    return ChatResponse(response=response)
""",

    os.path.join(app_dir, "conversation_routes.py"): """from fastapi import APIRouter

router = APIRouter()

@router.get("/history")
async def get_history():
    return {"history": []}
""",

    os.path.join(app_dir, "snippet_routes.py"): """from fastapi import APIRouter

router = APIRouter()

@router.get("/snippets")
async def get_snippets():
    return {"snippets": []}
""",

    os.path.join(app_dir, "services.py"): """def get_llm_response(prompt: str) -> str:
    # Placeholder AI logic
    return f"AI Response for: {prompt}"
""",

    os.path.join(app_dir, "schemas.py"): """from pydantic import BaseModel

class ChatRequest(BaseModel):
    prompt: str

class ChatResponse(BaseModel):
    response: str
""",

    os.path.join(base_dir, "requirements.txt"): """fastapi
uvicorn
pydantic
"""
}

# Create all files with content
for path, content in files_content.items():
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

print(f"✅ Backend structure created successfully in '{base_dir}' folder!")
