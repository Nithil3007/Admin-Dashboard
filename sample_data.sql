-- ============================================================================
-- SAMPLE DATA FOR Medical Transcription API Database
-- ============================================================================

-- Clear existing data from all tables
-- The order is important to avoid foreign key constraint violations.
TRUNCATE TABLE
    user_tiers, tiers, users, patients, visits, jobs, transcriptions, aws_transcribe_jobs, 
    clinical_insights, documents, differential_diagnosis, billing_codes_analysis, visit_billing_code, 
    customer_settings, schema_metadata
RESTART IDENTITY CASCADE;

-- Insert default tier configurations from the original schema
INSERT INTO tiers (name, description, status, max_transcriptions_per_month, max_storage_gb, max_users, 
                  features, price_usd_cents, billing_period, sort_order, is_trial, trial_duration_days)
VALUES 
('Free Trial', 'Free trial with limited features', 'active', 5, 1, 1, 
 '{"basic_transcription": true, "summary": false, "insights": false}'::jsonb, 0, 'one_time', 1, true, 14),
('Basic', 'Basic plan for individual practitioners', 'active', 100, 10, 1,
 '{"basic_transcription": true, "summary": true, "insights": false}'::jsonb, 1999, 'monthly', 2, false, null),
('Professional', 'Professional plan for small practices', 'active', 500, 50, 5,
 '{"basic_transcription": true, "summary": true, "insights": true, "api_access": true}'::jsonb, 4999, 'monthly', 3, false, null),
('Enterprise', 'Enterprise plan for large organizations', 'active', null, null, 50,
 '{"basic_transcription": true, "summary": true, "insights": true, "api_access": true, "custom_integration": true}'::jsonb, 9999, 'monthly', 4, false, null)
ON CONFLICT (name) DO NOTHING;

-- Insert sample users (doctors)
INSERT INTO users (user_id, idp_id, full_name, email, role, medical_specialty, phone_number, gender) VALUES
('user-001', 'idp-001', 'Dr. Alice Wonderland', 'alice.wonderland@clinic.com', 'doctor', 'CARDIOLOGY', '555-0101', 'Female'),
('user-002', 'idp-002', 'Dr. Bob Builder', 'bob.builder@clinic.com', 'doctor', 'PEDIATRICS', '555-0102', 'Male'),
('user-003', 'idp-003', 'Dr. Charlie Chaplin', 'charlie.chaplin@clinic.com', 'doctor', 'NEUROLOGY', '555-0103', 'Male'),
('user-004', 'idp-004', 'Dr. Diana Prince', 'diana.prince@clinic.com', 'doctor', 'PRIMARYCARE', '555-0104', 'Female'),
('user-005', 'idp-005', 'Dr. Eve Adams', 'eve.adams@clinic.com', 'doctor', 'DERMATOLOGY', '555-0105', 'Female'),
('user-006', 'idp-006', 'Dr. Frank Castle', 'frank.castle@clinic.com', 'doctor', 'ORTHOPEDICS', '555-0106', 'Male'),
('user-007', 'idp-007', 'Dr. Grace Hopper', 'grace.hopper@clinic.com', 'doctor', 'ONCOLOGY', '555-0107', 'Female'),
('user-008', 'idp-008', 'Dr. Hank Pym', 'hank.pym@clinic.com', 'doctor', 'GASTROENTEROLOGY', '555-0108', 'Male'),
('user-009', 'idp-009', 'Dr. Irene Adler', 'irene.adler@clinic.com', 'doctor', 'UROLOGY', '555-0109', 'Female'),
('user-010', 'idp-010', 'Dr. Jack Sparrow', 'jack.sparrow@clinic.com', 'doctor', 'PULMONOLOGY', '555-0110', 'Male'),
('user-011', 'idp-011', 'Dr. Kara Danvers', 'kara.danvers@clinic.com', 'doctor', 'ENDOCRINOLOGY', '555-0111', 'Female'),
('user-012', 'idp-012', 'Dr. Luke Skywalker', 'luke.skywalker@clinic.com', 'doctor', 'RHEUMATOLOGY', '555-0112', 'Male'),
('user-013', 'idp-013', 'Dr. Mulan Fa', 'mulan.fa@clinic.com', 'doctor', 'HEMATOLOGY', '555-0113', 'Female'),
('user-014', 'idp-014', 'Dr. Neo Anderson', 'neo.anderson@clinic.com', 'doctor', 'NEPHROLOGY', '555-0114', 'Male'),
('user-015', 'idp-015', 'Dr. Olivia Benson', 'olivia.benson@clinic.com', 'doctor', 'INFECTIOUSDISEASE', '555-0115', 'Female');

-- Assign tiers to users
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-001',
    (SELECT id FROM tiers WHERE name = 'Professional'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-002',
    (SELECT id FROM tiers WHERE name = 'Basic'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-003',
    (SELECT id FROM tiers WHERE name = 'Enterprise'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-004',
    (SELECT id FROM tiers WHERE name = 'Free Trial'),
    true,
    NOW() + INTERVAL '14 days';
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-005',
    (SELECT id FROM tiers WHERE name = 'Professional'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-006',
    (SELECT id FROM tiers WHERE name = 'Basic'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-007',
    (SELECT id FROM tiers WHERE name = 'Enterprise'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-008',
    (SELECT id FROM tiers WHERE name = 'Free Trial'),
    true,
    NOW() + INTERVAL '14 days';
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-009',
    (SELECT id FROM tiers WHERE name = 'Professional'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-010',
    (SELECT id FROM tiers WHERE name = 'Basic'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-011',
    (SELECT id FROM tiers WHERE name = 'Enterprise'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-012',
    (SELECT id FROM tiers WHERE name = 'Free Trial'),
    true,
    NOW() + INTERVAL '14 days';
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-013',
    (SELECT id FROM tiers WHERE name = 'Professional'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-014',
    (SELECT id FROM tiers WHERE name = 'Basic'),
    true,
    NULL;
INSERT INTO user_tiers (user_id, tier_id, is_active, expires_at)
SELECT 
    'user-015',
    (SELECT id FROM tiers WHERE name = 'Enterprise'),
    true,
    NULL;

-- Insert sample patients
INSERT INTO patients (patient_id, full_name, doctor_id, phone_number, email, gender, medical_record_number) VALUES
('patient-001', 'John Smith', 'user-001', '555-0201', 'john.smith@email.com', 'Male', 'MRN001'),
('patient-002', 'Jane Doe', 'user-001', '555-0202', 'jane.doe@email.com', 'Female', 'MRN002'),
('patient-003', 'Peter Pan', 'user-002', '555-0203', 'peter.pan@email.com', 'Male', 'MRN003'),
('patient-004', 'Mary Poppins', 'user-002', '555-0204', 'mary.poppins@email.com', 'Female', 'MRN004'),
('patient-005', 'David Copperfield', 'user-003', '555-0205', 'david.copperfield@email.com', 'Male', 'MRN005'),
('patient-006', 'Frodo Baggins', 'user-006', '555-0206', 'frodo.baggins@email.com', 'Male', 'MRN006'),
('patient-007', 'Gollum Smeagol', 'user-007', '555-0207', 'gollum.smeagol@email.com', 'Male', 'MRN007'),
('patient-008', 'Hermione Granger', 'user-008', '555-0208', 'hermione.granger@email.com', 'Female', 'MRN008'),
('patient-009', 'Indiana Jones', 'user-009', '555-0209', 'indiana.jones@email.com', 'Male', 'MRN009'),
('patient-010', 'James Bond', 'user-010', '555-0210', 'james.bond@email.com', 'Male', 'MRN010'),
('patient-011', 'Katniss Everdeen', 'user-011', '555-0211', 'katniss.everdeen@email.com', 'Female', 'MRN011'),
('patient-012', 'Legolas Greenleaf', 'user-012', '555-0212', 'legolas.greenleaf@email.com', 'Male', 'MRN012'),
('patient-013', 'Max Rockatansky', 'user-013', '555-0213', 'max.rockatansky@email.com', 'Male', 'MRN013'),
('patient-014', 'Nancy Drew', 'user-014', '555-0214', 'nancy.drew@email.com', 'Female', 'MRN014'),
('patient-015', 'Optimus Prime', 'user-015', '555-0215', 'optimus.prime@email.com', 'Male', 'MRN015');

-- Insert sample visits
INSERT INTO visits (visit_id, patient_id, doctor_id, visit_date, visit_reason) VALUES
('visit-001', 'patient-001', 'user-001', '2024-01-15 10:30:00', 'Annual Physical Exam'),
('visit-002', 'patient-002', 'user-001', '2024-01-16 11:00:00', 'Follow-up for hypertension'),
('visit-003', 'patient-003', 'user-002', '2024-01-17 09:00:00', 'Childhood immunizations'),
('visit-004', 'patient-004', 'user-002', '2024-01-18 14:30:00', 'Flu symptoms'),
('visit-005', 'patient-005', 'user-003', '2024-01-19 16:00:00', 'Consultation for chronic migraines'),
('visit-006', 'patient-006', 'user-006', '2024-01-20 10:00:00', 'Knee pain'),
('visit-007', 'patient-007', 'user-007', '2024-01-21 11:30:00', 'Chemotherapy session'),
('visit-008', 'patient-008', 'user-008', '2024-01-22 09:45:00', 'Abdominal pain'),
('visit-009', 'patient-009', 'user-009', '2024-01-23 13:00:00', 'Kidney stone'),
('visit-010', 'patient-010', 'user-010', '2024-01-24 15:15:00', 'Asthma follow-up'),
('visit-011', 'patient-011', 'user-011', '2024-01-25 08:30:00', 'Diabetes management'),
('visit-012', 'patient-012', 'user-012', '2024-01-26 12:00:00', 'Arthritis consultation'),
('visit-013', 'patient-013', 'user-013', '2024-01-27 14:00:00', 'Anemia check-up'),
('visit-014', 'patient-014', 'user-014', '2024-01-28 16:45:00', 'Kidney function test'),
('visit-015', 'patient-015', 'user-015', '2024-01-29 10:00:00', 'Fever and cough');

-- Insert sample jobs
INSERT INTO jobs (job_id, file_name, status, patient_id, doctor_id, visit_id, s3_url) VALUES
('job-001', 'rec-20240115-1030.mp3', 'completed', 'patient-001', 'user-001', 'visit-001', 's3://bucket/rec-20240115-1030.mp3'),
('job-002', 'rec-20240116-1100.mp3', 'completed', 'patient-002', 'user-001', 'visit-002', 's3://bucket/rec-20240116-1100.mp3'),
('job-003', 'rec-20240117-0900.mp3', 'processing', 'patient-003', 'user-002', 'visit-003', 's3://bucket/rec-20240117-0900.mp3'),
('job-004', 'rec-20240118-1430.mp3', 'failed', 'patient-004', 'user-002', 'visit-004', 's3://bucket/rec-20240118-1430.mp3'),
('job-005', 'rec-20240119-1600.mp3', 'completed', 'patient-005', 'user-003', 'visit-005', 's3://bucket/rec-20240119-1600.mp3'),
('job-006', 'rec-20240120-1000.mp3', 'completed', 'patient-006', 'user-006', 'visit-006', 's3://bucket/rec-20240120-1000.mp3'),
('job-007', 'rec-20240121-1130.mp3', 'completed', 'patient-007', 'user-007', 'visit-007', 's3://bucket/rec-20240121-1130.mp3'),
('job-008', 'rec-20240122-0945.mp3', 'processing', 'patient-008', 'user-008', 'visit-008', 's3://bucket/rec-20240122-0945.mp3'),
('job-009', 'rec-20240123-1300.mp3', 'failed', 'patient-009', 'user-009', 'visit-009', 's3://bucket/rec-20240123-1300.mp3'),
('job-010', 'rec-20240124-1515.mp3', 'completed', 'patient-010', 'user-010', 'visit-010', 's3://bucket/rec-20240124-1515.mp3'),
('job-011', 'rec-20240125-0830.mp3', 'completed', 'patient-011', 'user-011', 'visit-011', 's3://bucket/rec-20240125-0830.mp3'),
('job-012', 'rec-20240126-1200.mp3', 'completed', 'patient-012', 'user-012', 'visit-012', 's3://bucket/rec-20240126-1200.mp3'),
('job-013', 'rec-20240127-1400.mp3', 'processing', 'patient-013', 'user-013', 'visit-013', 's3://bucket/rec-20240127-1400.mp3'),
('job-014', 'rec-20240128-1645.mp3', 'failed', 'patient-014', 'user-014', 'visit-014', 's3://bucket/rec-20240128-1645.mp3'),
('job-015', 'rec-20240129-1100.mp3', 'completed', 'patient-001', 'user-001', 'visit-001', 's3://bucket/rec-20240129-1100.mp3'),
('job-016', 'rec-20240129-1200.mp3', 'completed', 'patient-002', 'user-001', 'visit-002', 's3://bucket/rec-20240129-1200.mp3'),
('job-017', 'rec-20240129-1300.mp3', 'failed', 'patient-003', 'user-002', 'visit-003', 's3://bucket/rec-20240129-1300.mp3'),
('job-018', 'rec-20240129-1400.mp3', 'processing', 'patient-004', 'user-002', 'visit-004', 's3://bucket/rec-20240129-1400.mp3'),
('job-019', 'rec-20240129-1500.mp3', 'completed', 'patient-005', 'user-003', 'visit-005', 's3://bucket/rec-20240129-1500.mp3'),
('job-020', 'rec-20240130-0900.mp3', 'failed', 'patient-006', 'user-006', 'visit-006', 's3://bucket/rec-20240130-0900.mp3'),
('job-021', 'rec-20240130-1000.mp3', 'completed', 'patient-007', 'user-007', 'visit-007', 's3://bucket/rec-20240130-1000.mp3'),
('job-022', 'rec-20240130-1100.mp3', 'completed', 'patient-008', 'user-008', 'visit-008', 's3://bucket/rec-20240130-1100.mp3'),
('job-023', 'rec-20240130-1200.mp3', 'processing', 'patient-009', 'user-009', 'visit-009', 's3://bucket/rec-20240130-1200.mp3'),
('job-024', 'rec-20240130-1300.mp3', 'completed', 'patient-010', 'user-010', 'visit-010', 's3://bucket/rec-20240130-1300.mp3'),
('job-025', 'rec-20240131-0900.mp3', 'completed', 'patient-011', 'user-011', 'visit-011', 's3://bucket/rec-20240131-0900.mp3'),
('job-026', 'rec-20240131-1000.mp3', 'failed', 'patient-012', 'user-012', 'visit-012', 's3://bucket/rec-20240131-1000.mp3'),
('job-027', 'rec-20240131-1100.mp3', 'completed', 'patient-013', 'user-013', 'visit-013', 's3://bucket/rec-20240131-1100.mp3'),
('job-028', 'rec-20240131-1200.mp3', 'processing', 'patient-014', 'user-014', 'visit-014', 's3://bucket/rec-20240131-1200.mp3'),
('job-029', 'rec-20240131-1300.mp3', 'completed', 'patient-015', 'user-015', 'visit-015', 's3://bucket/rec-20240131-1300.mp3'),
('job-030', 'rec-20240201-0900.mp3', 'completed', 'patient-001', 'user-001', 'visit-001', 's3://bucket/rec-20240201-0900.mp3'),
('job-031', 'rec-20240201-1000.mp3', 'failed', 'patient-002', 'user-001', 'visit-002', 's3://bucket/rec-20240201-1000.mp3'),
('job-032', 'rec-20240201-1100.mp3', 'completed', 'patient-003', 'user-002', 'visit-003', 's3://bucket/rec-20240201-1100.mp3'),
('job-033', 'rec-20240201-1200.mp3', 'completed', 'patient-004', 'user-002', 'visit-004', 's3://bucket/rec-20240201-1200.mp3'),
('job-034', 'rec-20240201-1300.mp3', 'processing', 'patient-005', 'user-003', 'visit-005', 's3://bucket/rec-20240201-1300.mp3');

-- Insert sample transcriptions
INSERT INTO transcriptions (job_id, transcript, summary) VALUES
('job-001', 'Patient is a 45-year-old male presenting for his annual physical exam. He reports no new health concerns and feels generally well. Vital signs are stable. Physical exam is unremarkable.', 'Annual physical for a healthy 45-year-old male. No issues found.'),
('job-002', 'Patient returns for a follow-up on her hypertension. Blood pressure today is 130/85. She reports good adherence to her medication. We will continue the current regimen.', 'Hypertension follow-up. BP is 130/85. Continue current medication.'),
('job-005', 'Patient presents with chronic migraines. Discussed triggers and lifestyle modifications. Prescribed new medication.', 'Chronic migraines. Lifestyle changes and new medication prescribed.'),
('job-006', 'Patient complains of right knee pain after a fall. X-ray ordered to rule out fracture.', 'Right knee pain post-fall. X-ray ordered.'),
('job-007', 'Patient undergoing chemotherapy. Reports fatigue and nausea. Administered anti-emetics.', 'Chemotherapy side effects management.'),
('job-010', 'Asthma follow-up. Patient is using inhaler as prescribed. No recent exacerbations.', 'Asthma stable. Continue current treatment.'),
('job-011', 'Diabetes management review. Blood sugar levels are well-controlled. Discussed diet and exercise.', 'Diabetes well-controlled. Diet and exercise reinforced.'),
('job-012', 'Patient with rheumatoid arthritis. Reports joint stiffness in the morning. Adjusted medication.', 'Rheumatoid arthritis flare-up. Medication adjusted.');

-- Insert sample documents
INSERT INTO documents (document_id, patient_id, doctor_id, document_source, status, category, original_filename, s3_key) VALUES
('doc-001', 'patient-001', 'user-001', 'patient_upload', 'completed', 'Lab Report', 'blood_work_2024.pdf', 'docs/doc_001.pdf'),
('doc-002', 'patient-002', 'user-001', 'emr_sync', 'completed', 'Imaging', 'chest_xray.dcm', 'docs/doc_002.dcm'),
('doc-003', 'patient-005', 'user-003', 'fax', 'pending', 'Referral Letter', 'referral_neuro.tiff', 'docs/doc_003.tiff'),
('doc-004', 'patient-006', 'user-006', 'patient_upload', 'completed', 'X-Ray', 'knee_xray.dcm', 'docs/doc_004.dcm'),
('doc-005', 'patient-007', 'user-007', 'emr_sync', 'completed', 'Pathology Report', 'pathology_report.pdf', 'docs/doc_005.pdf'),
('doc-006', 'patient-008', 'user-008', 'fax', 'pending', 'Ultrasound', 'abdominal_ultrasound.tiff', 'docs/doc_006.tiff'),
('doc-007', 'patient-009', 'user-009', 'patient_upload', 'completed', 'CT Scan', 'ct_scan_abdomen.dcm', 'docs/doc_007.dcm'),
('doc-008', 'patient-010', 'user-010', 'emr_sync', 'completed', 'Pulmonary Function Test', 'pft_results.pdf', 'docs/doc_008.pdf'),
('doc-009', 'patient-011', 'user-011', 'fax', 'pending', 'Endocrinology Consult', 'endo_consult.tiff', 'docs/doc_009.tiff'),
('doc-010', 'patient-012', 'user-012', 'patient_upload', 'completed', 'Blood Test', 'rheumatoid_factor.pdf', 'docs/doc_010.pdf'),
('doc-011', 'patient-013', 'user-013', 'emr_sync', 'completed', 'Hematology Report', 'cbc_report.pdf', 'docs/doc_011.pdf'),
('doc-012', 'patient-014', 'user-014', 'fax', 'pending', 'Renal Panel', 'renal_panel.tiff', 'docs/doc_012.tiff'),
('doc-013', 'patient-015', 'user-015', 'patient_upload', 'completed', 'COVID-19 Test', 'covid_test_results.pdf', 'docs/doc_013.pdf');


-- Insert schema version metadata
INSERT INTO schema_metadata (key, value) 
VALUES 
    ('version', '1.0.0'),
    ('created_date', NOW()::text),
    ('description', 'Medical Transcription API Database Schema')
ON CONFLICT (key) DO UPDATE SET 
    value = EXCLUDED.value, 
    updated_at = NOW();
