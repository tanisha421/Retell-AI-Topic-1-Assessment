CREATE TABLE IF NOT EXISTS leads (
  lead_id TEXT PRIMARY KEY,
  user_name TEXT,
  phone_number TEXT NOT NULL,
  email TEXT,
  course_interest TEXT,
  lead_source TEXT,
  education TEXT,
  current_year TEXT,
  experience_level TEXT,
  career_goal TEXT,
  location TEXT,
  preferred_language TEXT DEFAULT 'English',
  suppression_status TEXT NOT NULL DEFAULT 'ELIGIBLE',
  disposition TEXT,
  qualification_score INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS call_logs (
  id BIGSERIAL PRIMARY KEY,
  call_id TEXT NOT NULL,
  lead_id TEXT,
  event_type TEXT NOT NULL,
  transcript JSONB,
  analysis JSONB,
  payload JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(call_id, event_type)
);
CREATE TABLE IF NOT EXISTS callbacks (
  id BIGSERIAL PRIMARY KEY,
  lead_id TEXT NOT NULL REFERENCES leads(lead_id),
  scheduled_at TIMESTAMPTZ NOT NULL,
  timezone TEXT NOT NULL DEFAULT 'Asia/Kolkata',
  priority TEXT NOT NULL DEFAULT 'normal',
  status TEXT NOT NULL DEFAULT 'SCHEDULED',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS suppressions (
  lead_id TEXT PRIMARY KEY,
  reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_callbacks_due ON callbacks(scheduled_at) WHERE status='SCHEDULED';
