-- ================================================================
-- DML.sql — Data Manipulation Language
-- Universidade Comunitária
-- ================================================================
-- Construído em aula com os alunos.
--
-- COMANDOS: INSERT · UPDATE · DELETE
-- ================================================================


-- ── INSERT em PESSOA ──────────────────────────────────────────

INSERT INTO PESSOA
    (nome, documento, logradouro, numero, complemento, bairro, cidade, estado, cep)
    VALUES 
    ('Agatha Cristina', '123.456.789-10', 'Rua das Margaridas', '123', 'APT 1', 'Centro', 'Sorocaba',
     'SP', '12345-678')

-- ── INSERT em ESTUDANTE ───────────────────────────────────────


-- ── INSERT em FUNCIONARIO ─────────────────────────────────────

INSERT INTO FUNCIONARIO
    (id_pessoa, registro_funcional, setor, data_admissao)
    VALUES 
    ('1', 'RF123456789', 'TI', '01/01/2026')

-- ── INSERT em DISCIPLINA ──────────────────────────────────────


-- ── INSERT em MATRICULA_DISCIPLINA ────────────────────────────


-- ── INSERT em MINISTRA ────────────────────────────────────────


-- ── INSERT em ORIENTACAO ──────────────────────────────────────


-- ─────────────────────────────────────────────────────────────


-- ── UPDATE ────────────────────────────────────────────────────


-- ── DELETE ────────────────────────────────────────────────────



