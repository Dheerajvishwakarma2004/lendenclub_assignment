from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>DevSecOps Assignment</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #0f172a;
                color: #e5e7eb;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            .card {
                background-color: #020617;
                padding: 30px;
                border-radius: 10px;
                width: 600px;
                box-shadow: 0 0 20px rgba(0,0,0,0.6);
            }
            h1 {
                color: #38bdf8;
            }
            ul {
                line-height: 1.8;
            }
            footer {
                margin-top: 20px;
                font-size: 14px;
                color: #9ca3af;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>DevSecOps Assignment – GET 2026</h1>
            <p>This application is deployed as part of a DevSecOps assignment.</p>

            <h3>Pipeline Features</h3>
            <ul>
                <li>CI/CD implemented using Jenkins</li>
                <li>Infrastructure security scanning using Trivy</li>
                <li>Vulnerabilities identified and remediated</li>
                <li>Application deployed on cloud with public access</li>
            </ul>

            <h3>Tech Stack</h3>
            <ul>
                <li>Python (Flask)</li>
                <li>Docker</li>
                <li>Jenkins</li>
                <li>Terraform</li>
                <li>AWS Cloud</li>
            </ul>

            <footer>
                Deployed by: Dheeraj Omprakash Vishwakarma<br>
                Assignment: DevSecOps – Secure Cloud Deployment
            </footer>
        </div>
    </body>
    </html>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
