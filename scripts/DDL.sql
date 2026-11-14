-- ================================================================
-- DDL.sql — Data Definition Language
-- Universidade Comunitária
-- ================================================================
-- Construído em aula com os alunos.
--
-- ENTIDADES DO MODELO:
--   Pessoa        → especialização TOTAL e SOBREPOSTA em:
--     ├── Estudante   (num_matricula, curso)
--     └── Funcionário (registro_funcional, data_admissao, setor)
--
--   Disciplina    (codigo, nome, carga_horaria)
--
-- RELACIONAMENTOS:
--   Orientacao        → Funcionário orienta Estudante  (1:N)
--   Ministra          → Funcionário ministra Disciplina (N:M)
--   Matricula_Disciplina → Estudante cursa Disciplina  (N:M)
--                         atributos: semestre, ano, nota_final
--
-- ENDEREÇO COMPOSTO de Pessoa:
--   logradouro, numero, complemento, bairro, cidade, estado, cep
-- ================================================================


-- ── 1. Tabela PESSOA ──────────────────────────────────────────

CREATE TABLE PESSOA (
    id_pessoa INTEGER PRIMARY KEY AUTOINCREMENT,
    id_orientador ,
    nome TEXT,
    documento TEXT NOT NULL UNIQUE,
    logradouro TEXT,
    numero TEXT,
    complemento TEXT,
    bairro TEXT,
    cidade TEXT,
    estado TEXT,
    cep INT
    );

-- ── 2. Tabela ESTUDANTE (especialização de Pessoa) ────────────

CREATE TABLE ESTUDANTE (
    id_pessoa INTEGER PRIMARY KEY PESSOA(id_pessoa),
    id_orientador INTEGER REFERENCES funcionario(id_pessoa),
    curso TEXT NOT NULL,
    num_matricula TEXT NOT NULL UNIQUE,
    id_orientador TEXT
    );

-- ── 3. Tabela FUNCIONARIO (especialização de Pessoa) ──────────

CREATE TABLE FUNCIONARIO (
    id_pessoa INTEGER PRIMARY KEY REFERENCES PESSOA(id_pessoa),
    registro_funcional TEXT NOT NULL UNIQUE,
    setor TEXT NOT NULL,
    data_admissao TEXT
    );

-- ── 4. Tabela DISCIPLINA ──────────────────────────────────────

CREATE TABLE DISCIPLINA (
    codigo_disciplina INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    carga INTEGER
    );

-- ── 5. Tabela MATRICULA_DISCIPLINA (N:M com atributos) ────────

CREATE TABLE MATRICULA (
    id_pessoa INTEGER PRIMARY KEY,
    codigo_disciplina INTEGER PRIMARY KEY,
    nota FLOAT,
    semestre INTEGER,
    ano INTEGER
    );

-- ── 6. Tabela MINISTRA (N:M Funcionário × Disciplina) ─────────

CREATE TABLE MINISTRA (
    id_pessoa INTEGER PRIMARY KEY,
    codigo_disciplina INTEGER PRIMARY KEY,
    aulas INTEGER
    );

-- ── 7. Tabela ORIENTACAO (autorrelacionamento via Funcionário) ─

CREATE TABLE ORIENTACAO (
    id_pessoa INTEGER PRIMARY KEY,
    codigo_disciplina INTEGER PRIMARY KEY,
    aulas INTEGER
    );
