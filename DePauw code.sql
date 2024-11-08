CREATE TABLE international_students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    country VARCHAR(50),
    field_of_study VARCHAR(50),
    student_count INTEGER,
    academic_year INTEGER DEFAULT 2024,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE countries_meta (
    country_id INTEGER PRIMARY KEY AUTOINCREMENT,
    country_name VARCHAR(50),
    continent VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE fields_meta (
    field_id INTEGER PRIMARY KEY AUTOINCREMENT,
    field_name VARCHAR(50),
    category VARCHAR(50),
    stem_field BOOLEAN
);

INSERT INTO countries_meta (country_name, continent, region) VALUES
    ('Bangladesh', 'Asia', 'South Asia'),
    ('Brazil', 'South America', 'Latin America'),
    ('Canada', 'North America', 'North America'),
    ('China', 'Asia', 'East Asia'),
    ('Colombia', 'South America', 'Latin America'),
    ('France', 'Europe', 'Western Europe'),
    ('Germany', 'Europe', 'Western Europe'),
    ('Hong Kong', 'Asia', 'East Asia'),
    ('India', 'Asia', 'South Asia'),
    ('Indonesia', 'Asia', 'Southeast Asia'),
    ('Iran', 'Asia', 'Middle East'),
    ('Japan', 'Asia', 'East Asia'),
    ('Korea (South)', 'Asia', 'East Asia'),
    ('Kuwait', 'Asia', 'Middle East'),
    ('Mexico', 'North America', 'Latin America'),
    ('Nepal', 'Asia', 'South Asia'),
    ('Nigeria', 'Africa', 'West Africa'),
    ('Pakistan', 'Asia', 'South Asia'),
    ('Saudi Arabia', 'Asia', 'Middle East'),
    ('Spain', 'Europe', 'Southern Europe'),
    ('Taiwan', 'Asia', 'East Asia'),
    ('Turkey/Türkiye', 'Asia', 'Middle East'),
    ('United Kingdom', 'Europe', 'Western Europe'),
    ('Vietnam', 'Asia', 'Southeast Asia');

INSERT INTO fields_meta (field_name, category, stem_field) VALUES
    ('Math & Computer Science', 'STEM', true),
    ('Engineering', 'STEM', true),
    ('Physical & Life Sciences', 'STEM', true),
    ('Business & Management', 'Business', false),
    ('Social Sciences', 'Social Sciences', false),
    ('Humanities', 'Arts & Humanities', false),
    ('Fine & Applied Arts', 'Arts & Humanities', false),
    ('Education', 'Education', false),
    ('Health Professions', 'Health Sciences', true),
    ('Intensive English', 'Language', false),
    ('Undeclared', 'Other', false),
    ('Unknown', 'Other', false);

INSERT INTO international_students (country, field_of_study, student_count)
VALUES 
    ('Bangladesh', 'Math & Computer Science', 3),
    ('Bangladesh', 'Unknown', 13),
    ('Brazil', 'Social Sciences', 13),
    ('Canada', 'Education', 1),
    ('Canada', 'Undeclared', 1),
    ('China', 'Engineering', 8),
    ('China', 'Fine & Applied Arts', 2),
    ('China', 'Humanities', 3),
    ('China', 'Math & Computer Science', 3),
    ('China', 'Undeclared', 6),
    ('Colombia', 'Undeclared', 7),
    ('France', 'Humanities', 2),
    ('Germany', 'Math & Computer Science', 6),
    ('Hong Kong', 'Business & Management', 3),
    ('India', 'Education', 1),
    ('India', 'Health Professions', 1),
    ('India', 'Humanities', 1),
    ('India', 'Physical & Life Sciences', 1),
    ('India', 'Social Sciences', 1),
    ('Indonesia', 'Engineering', 5),
    ('Indonesia', 'Math & Computer Science', 2),
    ('Iran', 'Engineering', 2),
    ('Iran', 'Physical & Life Sciences', 2),
    ('Iran', 'Undeclared', 5),
    ('Japan', 'Undeclared', 4),
    ('Korea (South)', 'Engineering', 1),
    ('Korea (South)', 'Math & Computer Science', 1),
    ('Korea (South)', 'Undeclared', 3),
    ('Kuwait', 'Math & Computer Science', 4),
    ('Mexico', 'Engineering', 2),
    ('Mexico', 'Math & Computer Science', 1),
    ('Nepal', 'Math & Computer Science', 14),
    ('Nigeria', 'Math & Computer Science', 1),
    ('Pakistan', 'Math & Computer Science', 16),
    ('Saudi Arabia', 'Math & Computer Science', 1),
    ('Saudi Arabia', 'Physical & Life Sciences', 8),
    ('Saudi Arabia', 'Social Sciences', 8),
    ('Saudi Arabia', 'Undeclared', 7),
    ('Spain', 'Social Sciences', 4),
    ('Spain', 'Undeclared', 4),
    ('Taiwan', 'Business & Management', 8),
    ('Taiwan', 'Education', 1),
    ('Taiwan', 'Engineering', 3),
    ('Turkey/Türkiye', 'Humanities', 1),
    ('Turkey/Türkiye', 'Math & Computer Science', 2),
    ('United Kingdom', 'Social Sciences', 1),
    ('Vietnam', 'Math & Computer Science', 10),
    ('Vietnam', 'Physical & Life Sciences', 48),
    ('Vietnam', 'Social Sciences', 17),
    ('Vietnam', 'Undeclared', 46);

CREATE VIEW country_totals AS
SELECT 
    i.country,
    c.continent,
    c.region,
    SUM(i.student_count) as total_students,
    COUNT(DISTINCT i.field_of_study) as unique_fields,
    ROUND(100.0 * SUM(CASE WHEN f.stem_field THEN i.student_count ELSE 0 END) / SUM(i.student_count), 2) as stem_percentage
FROM international_students i
JOIN countries_meta c ON i.country = c.country_name
LEFT JOIN fields_meta f ON i.field_of_study = f.field_name
GROUP BY i.country, c.continent, c.region
ORDER BY total_students DESC;

CREATE VIEW field_totals AS
SELECT 
    i.field_of_study,
    f.category,
    f.stem_field,
    SUM(i.student_count) as total_students,
    COUNT(DISTINCT i.country) as number_of_countries,
    ROUND(100.0 * SUM(i.student_count) / (SELECT SUM(student_count) FROM international_students), 2) as percentage_of_total
FROM international_students i
LEFT JOIN fields_meta f ON i.field_of_study = f.field_name
GROUP BY i.field_of_study, f.category, f.stem_field
ORDER BY total_students DESC;

CREATE VIEW regional_analysis AS
SELECT 
    c.continent,
    c.region,
    f.category,
    SUM(i.student_count) as total_students,
    COUNT(DISTINCT i.country) as number_of_countries,
    COUNT(DISTINCT i.field_of_study) as number_of_fields,
    ROUND(100.0 * SUM(CASE WHEN f.stem_field THEN i.student_count ELSE 0 END) / SUM(i.student_count), 2) as stem_percentage
FROM international_students i
JOIN countries_meta c ON i.country = c.country_name
LEFT JOIN fields_meta f ON i.field_of_study = f.field_name
GROUP BY c.continent, c.region, f.category;

CREATE VIEW stem_analysis AS
SELECT 
    i.country,
    c.region,
    SUM(CASE WHEN f.stem_field THEN i.student_count ELSE 0 END) as stem_students,
    SUM(CASE WHEN NOT f.stem_field THEN i.student_count ELSE 0 END) as non_stem_students,
    ROUND(100.0 * SUM(CASE WHEN f.stem_field THEN i.student_count ELSE 0 END) / 
        NULLIF(SUM(i.student_count), 0), 2) as stem_percentage
FROM international_students i
JOIN countries_meta c ON i.country = c.country_name
LEFT JOIN fields_meta f ON i.field_of_study = f.field_name
GROUP BY i.country, c.region
HAVING SUM(i.student_count) > 0
ORDER BY stem_percentage DESC;

CREATE VIEW diversity_index AS
SELECT 
    country,
    COUNT(DISTINCT field_of_study) as field_diversity,
    SUM(student_count) as total_students,
    ROUND(100.0 * COUNT(DISTINCT field_of_study) / 
        (SELECT COUNT(DISTINCT field_of_study) FROM international_students), 2) as diversity_score
FROM international_students
GROUP BY country
HAVING SUM(student_count) >= 5
ORDER BY field_diversity DESC, total_students DESC;

SELECT 
    continent,
    COUNT(DISTINCT i.country) as number_of_countries,
    SUM(i.student_count) as total_students,
    ROUND(AVG(stem_percentage), 2) as avg_stem_percentage,
    COUNT(DISTINCT i.field_of_study) as unique_fields
FROM international_students i
JOIN countries_meta c ON i.country = c.country_name
JOIN stem_analysis s ON i.country = s.country
GROUP BY continent
ORDER BY total_students DESC;

SELECT 
    f.category,
    COUNT(DISTINCT i.field_of_study) as fields_in_category,
    SUM(i.student_count) as total_students,
    COUNT(DISTINCT i.country) as countries_represented,
    ROUND(100.0 * SUM(i.student_count) / (SELECT SUM(student_count) FROM international_students), 2) as percentage_of_total
FROM international_students i
JOIN fields_meta f ON i.field_of_study = f.field_name
GROUP BY f.category
ORDER BY total_students DESC;

SELECT 
    i.country,
    c.region,
    f.category,
    SUM(i.student_count) as students,
    RANK() OVER (PARTITION BY f.category ORDER BY SUM(i.student_count) DESC) as rank_in_category
FROM international_students i
JOIN countries_meta c ON i.country = c.country_name
JOIN fields_meta f ON i.field_of_study = f.field_name
GROUP BY i.country, c.region, f.category
HAVING rank_in_category <= 3
ORDER BY f.category, rank_in_category;

CREATE VIEW year_over_year_comparison AS
SELECT 
    i.country,
    i.field_of_study,
    i.academic_year,
    i.student_count as current_count,
    LAG(i.student_count) OVER (
        PARTITION BY i.country, i.field_of_study 
        ORDER BY i.academic_year
    ) as previous_year_count,
    ROUND(100.0 * (i.student_count - LAG(i.student_count) OVER (
        PARTITION BY i.country, i.field_of_study 
        ORDER BY i.academic_year
    )) / NULLIF(LAG(i.student_count) OVER (
        PARTITION BY i.country, i.field_of_study 
        ORDER BY i.academic_year
    ), 0), 2) as percentage_change
FROM international_students i;

CREATE INDEX idx_country ON international_students(country);
CREATE INDEX idx_field ON international_students(field_of_study);
CREATE INDEX idx_country_field ON international_students(country, field_of_study);
CREATE INDEX idx_stem_fields ON fields_meta(stem_field);
CREATE INDEX idx_country_region ON countries_meta(country_name, region);