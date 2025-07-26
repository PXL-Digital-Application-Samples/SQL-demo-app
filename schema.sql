-- schema.sql
-- PostgreSQL schema and PL/pgSQL functions for User Management API

-- Create schema
CREATE SCHEMA IF NOT EXISTS api;

-- Create users table
CREATE TABLE IF NOT EXISTS api.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create update timestamp trigger
CREATE OR REPLACE FUNCTION api.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE
    ON api.users FOR EACH ROW EXECUTE FUNCTION api.update_updated_at_column();

-- Seed initial data
INSERT INTO api.users (name, email) VALUES 
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Charlie', 'charlie@example.com')
ON CONFLICT (email) DO NOTHING;

-- Create custom functions for more complex operations if needed

-- Function to create user with validation
CREATE OR REPLACE FUNCTION api.create_user(
    p_name VARCHAR,
    p_email VARCHAR
) RETURNS api.users AS $$
DECLARE
    new_user api.users;
BEGIN
    IF p_name IS NULL OR p_email IS NULL OR p_name = '' OR p_email = '' THEN
        RAISE EXCEPTION 'Name and email are required' USING ERRCODE = '23502';
    END IF;
    
    INSERT INTO api.users (name, email)
    VALUES (p_name, p_email)
    RETURNING * INTO new_user;
    
    RETURN new_user;
END;
$$ LANGUAGE plpgsql;

-- Function to update user
CREATE OR REPLACE FUNCTION api.update_user(
    p_id INTEGER,
    p_name VARCHAR DEFAULT NULL,
    p_email VARCHAR DEFAULT NULL
) RETURNS api.users AS $$
DECLARE
    updated_user api.users;
BEGIN
    UPDATE api.users
    SET 
        name = COALESCE(p_name, name),
        email = COALESCE(p_email, email)
    WHERE id = p_id
    RETURNING * INTO updated_user;
    
    IF updated_user IS NULL THEN
        RAISE EXCEPTION 'User not found' USING ERRCODE = 'P0002';
    END IF;
    
    RETURN updated_user;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions for PostgREST
GRANT USAGE ON SCHEMA api TO web_anon;
GRANT SELECT, INSERT, UPDATE, DELETE ON api.users TO web_anon;
GRANT USAGE, SELECT ON SEQUENCE api.users_id_seq TO web_anon;
GRANT EXECUTE ON FUNCTION api.create_user TO web_anon;
GRANT EXECUTE ON FUNCTION api.update_user TO web_anon;