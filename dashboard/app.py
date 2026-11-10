import os
import streamlit as st
import psycopg

st.title("Mental Health Data Platform")

with psycopg.connect(
    host=os.environ["POSTGRES_HOST"],
    port=os.environ["POSTGRES_PORT"],
    dbname=os.environ["POSTGRES_DB"],
    user=os.environ["POSTGRES_USER"],
    password=os.environ["POSTGRES_PASSWORD"]
) as conn:
    version = conn.execute("SELECT version()").fetchone()[0]

    st.write("Connected to:", version)