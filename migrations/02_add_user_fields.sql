-- migrations/002_add_user_fields.sql
-- Example migration to add new fields to users table

-- Add new columns
ALTER TABLE api.users 
ADD COLUMN IF NOT EXISTS phone VARCHAR(50),
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true,
ADD COLUMN IF NOT EXISTS last_login TIMESTAMP;

-- Create index for email lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON api.users(email);

-- Create a view for active users
CREATE OR REPLACE VIEW api.active_users AS
SELECT * FROM api.users WHERE is_active = true;

-- Grant permissions on the new view
GRANT SELECT ON api.active_users TO web_anon;

-- Example function to record login
CREATE OR REPLACE FUNCTION api.record_login(
    p_user_id INTEGER
) RETURNS api.users AS $$
DECLARE
    updated_user api.users;
BEGIN
    UPDATE api.users
    SET last_login = CURRENT_TIMESTAMP
    WHERE id = p_user_id
    RETURNING * INTO updated_user;
    
    IF updated_user IS NULL THEN
        RAISE EXCEPTION 'User not found' USING ERRCODE = 'P0002';
    END IF;
    
    RETURN updated_user;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION api.record_login TO web_anon;