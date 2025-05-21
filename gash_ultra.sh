#!/bin/bash
# Gash Ultra Bootstrap Script - Ubuntu Runtime Edition

echo "🔁 Setting up Gash Ultra Runtime..."

# 1. Define install path
INSTALL_DIR="$HOME/.gash_ultra"
CORE_REPO="https:/Shaqattack609/luxurious_creations.git/Gash.git/github.com/"  # <-- Replace with your repo

# 2. Create install directory
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit 1

# 3. Set up Python virtual environment
echo "🐍 Creating Python venv..."
python3 -m venv venv
source venv/bin/activate

# 4. Upgrade pip & install dependencies
echo "📦 Installing Python dependencies..."
pip install --upgrade pip
pip install pyttsx3 speechrecognition pyaudio

# 5. Clone Gash Core (skip if already exists)
if [ ! -d "$INSTALL_DIR/core" ]; then
  echo "📁 Cloning Gash Core..."
  git clone "$CORE_REPO" core
else
  echo "✔️ Gash Core already exists. Skipping clone."
fi

# 6. Create launcher script
echo "⚙️ Creating launcher..."
cat > "$INSTALL_DIR/launch_gash.sh" << 'EOF'
#!/bin/bash
# Gash Ultra Boot Script - Clean Edition
source ~/.gash_ultra/venv/bin/activate
python ~/.gash_ultra/core/main.py
EOF

chmod +x "$INSTALL_DIR/launch_gash.sh"

# 7. Install Node and PM2 if not present
if ! command -v pm2 &> /dev/null; then
  echo "⬇️ Installing Node.js and PM2..."
  curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  sudo apt install -y nodejs
  sudo npm install -g pm2
fi

# 8. Start Gash with PM2
echo "🚀 Registering Gash with PM2..."
pm2 start "$INSTALL_DIR/launch_gash.sh" --name gash_ultra
pm2 save
pm2 startup systemd -u $USER --hp $HOME

echo "✅ Gash Ultra setup complete. Logs below:"
pm2 logs gash_ultra

