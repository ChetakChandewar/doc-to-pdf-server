import os
import subprocess
from flask import Flask, request, jsonify, send_file
from werkzeug.utils import secure_filename

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
CONVERTED_FOLDER = "converted"

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(CONVERTED_FOLDER, exist_ok=True)

@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "DOCX/XLSX/PPTX to PDF API is running"}), 200

@app.route("/convert", methods=["POST"])
def convert_to_pdf():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    filename = secure_filename(file.filename)
    input_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(input_path)

    # Check file format
    ext = filename.split(".")[-1].lower()
    if ext not in ["docx", "xlsx", "pptx"]:
        return jsonify({"error": "Invalid file format. Only DOCX, XLSX, and PPTX are supported."}), 400

    # Define output PDF path
    pdf_filename = os.path.splitext(filename)[0] + ".pdf"
    output_path = os.path.join(CONVERTED_FOLDER, pdf_filename)

    try:
        # Force unoconv to use the LibreOffice running instance
        subprocess.run(["unoconv", "-c", "socket,host=127.0.0.1,port=2002", "-f", "pdf", "-o", output_path, input_path], check=True)
        return send_file(output_path, as_attachment=True)
    except subprocess.CalledProcessError as e:
        return jsonify({"error": f"Conversion failed: {e}"}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
