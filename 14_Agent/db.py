import sqlite3
from pathlib import Path
from datetime import datetime, timezone

DB_PATH = Path(__file__).resolve().parent / "meetings.db"

def get_connection() -> sqlite3.Connection:
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db() -> None:
    with get_connection() as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS meetings (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title VARCHAR(1000) NOT NULL,
                people VARCHAR(1000) NOT NULL,
                notes TEXT NOT NULL,
                summary TEXT NOT NULL,
                actions TEXT NOT NULL,
                result TEXT NOT NULL,
                created_at VARCHAR(100) NOT NULL
            )
            """
        )
        conn.commit()

def save_meeting(title: str, people: str, notes: str, summary: str, actions: str, result: str) -> int:
    created_at = datetime.now(timezone.utc).isoformat(timespec="seconds")
    with get_connection() as conn:
        cursoor = conn.execute(
            """
            INSERT INTO meetings (title, people, notes, summary, actions, result, created_at) VALUES
            (?, ?, ?, ?, ?, ?, ?)
            """, (title, people, notes, summary, actions, result, created_at)
        )
        conn.commit()
        return int(cursoor.lastrowid)