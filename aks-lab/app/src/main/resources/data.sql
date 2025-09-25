-- Insert sample customer data
INSERT INTO customers (name, email, created_at, updated_at) VALUES
('John Doe', 'john.doe@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Jane Smith', 'jane.smith@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Bob Johnson', 'bob.johnson@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Alice Brown', 'alice.brown@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Charlie Wilson', 'charlie.wilson@example.com', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (email) DO NOTHING;
