import socket

HOST = "0.0.0.0"
PORT = 4243
ANSWER = "TCP"

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(50)
    print(f"[exo2] Listening on {PORT}")

    while True:
        conn, addr = s.accept()
        with conn:
            conn.sendall(b"Bienvenue Exo2\nQuestion: Quel protocole est oriente connexion ? (TCP/UDP)\n> ")
            data = conn.recv(1024).decode(errors="ignore").strip().upper()
            if data == ANSWER:
                conn.sendall(b"OK ✅\n")
            else:
                conn.sendall(b"NON ❌\n")
