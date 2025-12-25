from fastapi import FastAPI, HTTPException
VALID_KEYS = ["YCLD-TEST-KEY"]
app = FastAPI()
@app.post("/ask")
def ask(prompt:str, user_role:str, license_key:str):
    if license_key not in VALID_KEYS:
        raise HTTPException(status_code=403, detail="Invalid License Key")
    return {"answer": f"تم الاستلام: {prompt} ({user_role})"}
