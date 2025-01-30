
CREATE TABLE example (
    id SERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL
);

INSERT INTO example (name) VALUES ('Sample Data 1'), ('Sample Data 2');
