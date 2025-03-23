import os
import subprocess
from flask import Flask, request, send_file

app = Flask(__name__)

UPLOAD_FOLDER = "/tmp"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route("/", methods=["GET"])
def home():
    return {"message": "DOCX to PDF Converter API is running!"}

@app.route("/convert", methods=["POST"])
def convert_docx_to_pdf():
    if "file" not in request.files:
        return {"error": "No file uploaded"}, 400

    file = request.files["file"]
    if file.filename == "":
        return {"error": "No file selected"}, 400

    input_path = os.path.join(UPLOAD_FOLDER, file.filename)
    output_path = os.path.join(UPLOAD_FOLDER, file.filename.replace(".docx", ".pdf"))

    file.save(input_path)

    try:
        # Convert DOCX to PDF using LibreOffice CLI
        subprocess.run(
            ["libreoffice", "--headless", "--convert-to", "pdf", input_path, "--outdir", UPLOAD_FOLDER], 
            check=True
        )

        if not os.path.exists(output_path):
            return {"error": "Conversion failed"}, 500

        return send_file(output_path, as_attachment=True)
    
    except Exception as e:
        return {"error": str(e)}, 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
