-- Create extensions for global language learning app
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "unaccent";

-- Create custom types for language learning
CREATE TYPE lesson_type AS ENUM ('vocabulary', 'grammar', 'pronunciation', 'conversation');
CREATE TYPE user_level AS ENUM ('A1', 'A2', 'B1', 'B2', 'C1', 'C2');
CREATE TYPE subscription_status AS ENUM ('free', 'premium', 'enterprise');

-- Set timezone for global usage
SET timezone = 'UTC';

-- Create system logs table for monitoring
CREATE TABLE IF NOT EXISTS system_logs (
                                           id SERIAL PRIMARY KEY,
                                           level VARCHAR(20) NOT NULL DEFAULT 'info',
    message TEXT NOT NULL,
    context JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );

-- Log successful initialization
INSERT INTO system_logs (level, message, context, created_at)
VALUES (
           'info',
           'Database initialized successfully for Learn English With Purga Global',
           '{"version": "1.0", "environment": "development"}',
           NOW()
       );

-- Create initial configuration table
CREATE TABLE IF NOT EXISTS app_config (
                                          key VARCHAR(100) PRIMARY KEY,
    value JSONB NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );

-- Insert initial configuration
INSERT INTO app_config (key, value, description) VALUES
                                                     ('supported_languages', '{"source": ["EN"], "targets": ["PT", "IT", "ES", "FR", "DE"]}', 'Languages supported by the platform'),
                                                     ('app_version', '"1.0.0"', 'Current application version'),
                                                     ('maintenance_mode', 'false', 'Whether the app is in maintenance mode'),
                                                     ('max_free_lessons', '5', 'Maximum lessons per day for free users')
    ON CONFLICT (key) DO NOTHING;