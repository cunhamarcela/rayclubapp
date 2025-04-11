-- Novas tabelas para o sistema de check-ins e bônus de desafios

-- Tabela de check-ins diários para desafios
CREATE TABLE challenge_check_ins (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  check_in_date TIMESTAMP WITH TIME ZONE NOT NULL,
  points INT NOT NULL DEFAULT 10,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, challenge_id, check_in_date::date)
);

-- Tabela de pontos de bônus para desafios
CREATE TABLE challenge_bonuses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id),
  challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  bonus_points INT NOT NULL,
  reason TEXT NOT NULL,
  awarded_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Segurança RLS
ALTER TABLE challenge_check_ins ENABLE ROW LEVEL SECURITY;
ALTER TABLE challenge_bonuses ENABLE ROW LEVEL SECURITY;

-- Políticas para check-ins
CREATE POLICY "Usuários podem ver check-ins de desafios em que participam"
  ON challenge_check_ins FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM challenge_participants
      WHERE challenge_participants.challenge_id = challenge_check_ins.challenge_id
      AND challenge_participants.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM challenges
      WHERE challenges.id = challenge_check_ins.challenge_id
      AND challenges.created_by = auth.uid()
    )
  );

CREATE POLICY "Usuários podem registrar seus próprios check-ins"
  ON challenge_check_ins FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Políticas para bônus
CREATE POLICY "Usuários podem ver bônus de desafios em que participam"
  ON challenge_bonuses FOR SELECT
  TO authenticated
  USING (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM challenge_participants
      WHERE challenge_participants.challenge_id = challenge_bonuses.challenge_id
      AND challenge_participants.user_id = auth.uid()
    ) OR
    EXISTS (
      SELECT 1 FROM challenges
      WHERE challenges.id = challenge_bonuses.challenge_id
      AND challenges.created_by = auth.uid()
    )
  );

CREATE POLICY "Administradores podem atribuir bônus"
  ON challenge_bonuses FOR INSERT
  TO authenticated
  WITH CHECK (
    user_id = auth.uid() OR
    EXISTS (
      SELECT 1 FROM challenges
      WHERE challenges.id = challenge_bonuses.challenge_id
      AND challenges.created_by = auth.uid()
    )
  );

-- Índices para melhor performance
CREATE INDEX idx_challenge_check_ins_user ON challenge_check_ins(user_id);
CREATE INDEX idx_challenge_check_ins_challenge ON challenge_check_ins(challenge_id);
CREATE INDEX idx_challenge_check_ins_date ON challenge_check_ins(check_in_date);
CREATE INDEX idx_challenge_bonuses_user ON challenge_bonuses(user_id);
CREATE INDEX idx_challenge_bonuses_challenge ON challenge_bonuses(challenge_id);

-- Adicionar novos campos à tabela challenge_progress
ALTER TABLE challenge_progress ADD COLUMN IF NOT EXISTS check_ins_count INT DEFAULT 0;
ALTER TABLE challenge_progress ADD COLUMN IF NOT EXISTS last_check_in TIMESTAMP WITH TIME ZONE;
ALTER TABLE challenge_progress ADD COLUMN IF NOT EXISTS consecutive_days INT DEFAULT 0;
ALTER TABLE challenge_progress ADD COLUMN IF NOT EXISTS completed BOOLEAN DEFAULT FALSE; 