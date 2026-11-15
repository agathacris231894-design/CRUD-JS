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

CREATE TABLE pessoa (
    codigo INTEGER PRIMARY KEY AUTOINCREMENT,
    documento TEXT NOT NULL UNIQUE,
    nome TEXT NOT NULL,
    logradouro TEXT,
    numero TEXT,
    complemento TEXT,
    bairro TEXT,
    cidade TEXT,
    estado TEXT,
    cep TEXT
);

-- ── 2. Tabela FUNCIONARIO (especialização de Pessoa) ──────────

CREATE TABLE funcionario (
    codigo INTEGER PRIMARY KEY,
    registro_funcional TEXT NOT NULL UNIQUE,
    data_admissao TEXT NOT NULL,
    setor_lotacao TEXT NOT NULL,

    FOREIGN KEY (codigo)
        REFERENCES pessoa(codigo)
        ON DELETE CASCADE
);

-- ── 3. Tabela ESTUDANTE (especialização de Pessoa) ────────────

CREATE TABLE estudante (
    codigo INTEGER PRIMARY KEY,
    matricula TEXT NOT NULL UNIQUE,
    curso TEXT NOT NULL,
    id_orientador INTEGER,

    FOREIGN KEY (codigo)
        REFERENCES pessoa(codigo)
        ON DELETE CASCADE,

    FOREIGN KEY (id_orientador)
        REFERENCES funcionario(codigo)
        ON DELETE SET NULL
);


-- ── 4. Tabela DISCIPLINA ──────────────────────────────────────

CREATE TABLE disciplina (
    codigo TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    carga_horaria INTEGER NOT NULL
        CHECK (carga_horaria > 0)
);

-- ── 5. Tabela MATRICULA_DISCIPLINA (N:M com atributos) ────────

CREATE TABLE matricula_disciplina (
    id_estudante INTEGER NOT NULL,
    disciplina_codigo TEXT NOT NULL,
    semestre INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    nota_final REAL,

    PRIMARY KEY (
        id_estudante,
        disciplina_codigo,
        semestre,
        ano
    ),

    FOREIGN KEY (id_estudante)
        REFERENCES ESTUDANTE(codigo),

    FOREIGN KEY (disciplina_codigo)
        REFERENCES DISCIPLINA(codigo),

    CHECK (semestre IN (1, 2)),
    CHECK (nota_final BETWEEN 0 AND 10)
);

-- ── 6. Tabela MINISTRA (N:M Funcionário × Disciplina) ─────────

CREATE TABLE ministra (
    id_funcionario INTEGER NOT NULL,
    disciplina_codigo TEXT NOT NULL,

    PRIMARY KEY (id_funcionario, disciplina_codigo),

    FOREIGN KEY (id_funcionario)
        REFERENCES FUNCIONARIO(codigo),

    FOREIGN KEY (disciplina_codigo)
        REFERENCES DISCIPLINA(codigo)
);

-- ── 7. Tabela ORIENTACAO ───────────────────────────────────────────────

CREATE TABLE orientacao (
    id_funcionario INTEGER NOT NULL,
    id_estudante INTEGER NOT NULL,

    PRIMARY KEY (id_estudante),

    FOREIGN KEY (id_funcionario)
        REFERENCES funcionario(codigo),

    FOREIGN KEY (id_estudante)
        REFERENCES estudante(codigo)
);