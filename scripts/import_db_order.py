import os
from pathlib import Path

import pymysql


def iter_sql_statements(sql_text: str):
    statement = []
    for line in sql_text.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("--"):
            continue
        statement.append(line)
        if stripped.endswith(";"):
            yield "\n".join(statement)
            statement = []


def main():
    host = os.getenv("DB_HOST", "127.0.0.1")
    port = int(os.getenv("DB_PORT", "3306"))
    user = os.getenv("DB_USER", "root")
    password = os.getenv("DB_PASSWORD", "")
    db_name = os.getenv("DB_NAME", "db_order")
    sql_path = Path(os.getenv("SQL_PATH", "db_order.sql"))

    if not sql_path.exists():
        raise FileNotFoundError(f"SQL file not found: {sql_path}")

    conn = pymysql.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        charset="utf8mb4",
        autocommit=True,
    )
    cur = conn.cursor()

    cur.execute(f"CREATE DATABASE IF NOT EXISTS `{db_name}` DEFAULT CHARACTER SET utf8mb4")
    cur.execute(f"USE `{db_name}`")

    sql_text = sql_path.read_text(encoding="utf-8")
    count = 0
    for stmt in iter_sql_statements(sql_text):
        cur.execute(stmt)
        count += 1

    cur.close()
    conn.close()
    print(f"Import finished. database={db_name}, statements={count}")


if __name__ == "__main__":
    main()
