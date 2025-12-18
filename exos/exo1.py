import socket

HOST = "0.0.0.0"
PORT = 4242

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((HOST, PORT))
    s.listen(50)
    print(f"[exo1] Listening on {PORT}")

    while True:
        conn, addr = s.accept()
        with conn:
            conn.sendall(b"Bienvenue Exo1\nQuestion: Port par defaut de SSH ?\n> ")
            data = conn.recv(1024).decode(errors="ignore").strip()
            if data == "22":
                conn.sendall(b"OK ✅\n")
            else:
                conn.sendall(b"NON ❌\n")
