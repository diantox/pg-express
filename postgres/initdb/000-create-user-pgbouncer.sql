CREATE USER pgbouncer WITH PASSWORD 'pgbouncer';
CREATE SCHEMA pgbouncer AUTHORIZATION pgbouncer;

CREATE FUNCTION pgbouncer.auth (_usename TEXT)
  RETURNS TABLE (usename NAME, passwd TEXT)
  LANGUAGE sql
    SECURITY DEFINER
    AS $$
      SELECT usename, passwd
      FROM pg_shadow
      WHERE usename = _usename
    $$;

REVOKE ALL PRIVILEGES ON FUNCTION pgbouncer.auth(_usename TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION pgbouncer.auth(_usename TEXT) TO pgbouncer;

COPY (
  SELECT usename, passwd
  FROM pg_shadow
  WHERE usename = 'pgbouncer'
)
  TO '/var/lib/pgbouncer/config/pgb_auth'
    WITH DELIMITER ' ' CSV FORCE QUOTE *;
