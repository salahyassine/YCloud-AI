#!/bin/bash

# 1️⃣ إعداد المتغيرات
USERNAME="Salahyassine"
REPO="YCloud-AI"
ZIP_NAME="YCloud_AI_Global.zip"

# 2️⃣ إنشاء المستودع على GitHub
gh auth login --web
gh repo create $USERNAME/$REPO --public --confirm

# 3️⃣ إنشاء مجلد المشروع المحلي
mkdir -p $REPO
cd $REPO

# 4️⃣ إنشاء المجلدات والخدمات
mkdir -p orchestrator rag/data/HR rag/data/Finance rag/data/Engineering web_ui/dashboard/dashboard_ui

# 5️⃣ سكريبت deploy_global_ai.sh
cat > deploy_global_ai.sh << 'EOF'
#!/bin/bash
PROJECT_DIR="$HOME/YCloud_AI_Global"
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR
mkdir -p rag/data/HR rag/data/Finance rag/data/Engineering

cat > docker-compose.yml <<EOL
version: '3.8'
services:
  orchestrator:
    build: ./orchestrator
    container_name: ai_orchestrator
    restart: always
    volumes:
      - ./rag/data:/app/rag/data
      - ./orchestrator:/app
    ports:
      - "8000:8000"
  web_ui:
    build: ./web_ui
    container_name: ai_web_ui
    restart: always
    depends_on:
      - orchestrator
    ports:
      - "8080:8080"
  dashboard:
    build: ./dashboard
    container_name: ai_dashboard
    restart: always
    ports:
      - "9090:9090"
EOL

echo "تم تشغيل كل الخدمات..."
docker-compose up -d --build
EOF

chmod +x deploy_global_ai.sh

# 6️⃣ ملفات Orchestrator (مثال رئيسي)
cat > orchestrator/main.py << 'EOF'
from fastapi import FastAPI, HTTPException
VALID_KEYS = ["YCLD-TEST-KEY"]
app = FastAPI()
@app.post("/ask")
def ask(prompt:str, user_role:str, license_key:str):
    if license_key not in VALID_KEYS:
        raise HTTPException(status_code=403, detail="Invalid License Key")
    return {"answer": f"تم الاستلام: {prompt} ({user_role})"}
EOF

# 7️⃣ إنشاء ZIP النهائي
zip -r $ZIP_NAME ./*

# 8️⃣ رفع المشروع إلى GitHub
git init
git add .
git commit -m "Initial YCloud AI release"
git branch -M main
git remote add origin https://github.com/$USERNAME/$REPO.git
git push -u origin main

# 9️⃣ إنشاء Release على GitHub (v1.0)
gh release create v1.0 $ZIP_NAME -t "YCloud AI Global Release v1.0" -n "Release جاهز للتحميل المباشر لجميع الأجهزة"

echo "✅ انتهى كل شيء! رابط التحميل المباشر:"
echo "https://github.com/$USERNAME/$REPO/releases/download/v1.0/$ZIP_NAME"
echo "=== SCRIPT TERMINÉ ==="
read -p "Appuyez sur ENTER pour fermer..."
