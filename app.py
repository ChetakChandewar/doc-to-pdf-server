import os
import subprocess
from flask import Flask, request, send_file

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
OUTPUT_FOLDER = "output"

# Ensure directories exist
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

def convert_to_pdf(input_path, output_path):
    try:
        subprocess.run(["unoconv", "-c", "socket,host=127.0.0.1,port=2002;urp;", "-f", "pdf", "-o", output_path, input_path], check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Conversion error: {e}")
        return False

@app.route("/")
def home():
    return "Welcome to the Document Conversion API!"

@app.route("/convert", methods=["POST"])
def convert():
    if "file" not in request.files:
        return {"error": "No file uploaded"}, 400

    file = request.files["file"]
    filename = file.filename
    file_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(file_path)

    output_file = os.path.join(OUTPUT_FOLDER, os.path.splitext(filename)[0] + ".pdf")

    if convert_to_pdf(file_path, output_file):
        return send_file(output_file, as_attachment=True)
    else:
        return {"error": "Conversion failed"}, 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
