-- init-roles.sql
-- Create roles for PostgREST

-- Create the anonymous role for PostgREST
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'web_anon') THEN
        CREATE ROLE web_anon NOLOGIN;
    END IF;
END
$$;

-- Grant connection permission
GRANT CONNECT ON DATABASE userdb TO web_anon;

-- You can also create an authenticator role if needed for JWT auth later
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'authenticator') THEN
        CREATE ROLE authenticator NOINHERIT LOGIN PASSWORD 'authenticator_password';
    END IF;
END
$$;

GRANT web_anon TO authenticator;