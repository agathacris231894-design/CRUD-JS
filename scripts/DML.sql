-- ================================================================
-- DML.sql — Data Manipulation Language
-- Universidade Comunitária (Exercícios de Carga, Atualização e Remoção)
-- ================================================================

PRAGMA foreign_keys = ON;


-- ── 1. INSERT em PESSOA ───────────────────────────────────────
-- Cadastrar pessoas com documento único e endereço composto.

INSERT INTO pessoa
    (nome, documento, logradouro, numero, complemento, bairro, cidade, estado, cep)
VALUES
    ('Agatha Cristina', '123.456.789-10', 'Rua das Margaridas', '123', 'APT 1', 'Centro', 'Sorocaba', 'SP', '12345-678');

INSERT INTO pessoa
    (nome, documento, logradouro, numero, complemento, bairro, cidade, estado, cep)
VALUES
    ('Maria Silva', '987.654.321-00', 'Rua das Acácias', '245', 'Casa 2', 'Jardim Europa', 'Sorocaba', 'SP', '18045-120');

INSERT INTO pessoa
    (nome, documento, logradouro, numero, complemento, bairro, cidade, estado, cep)
VALUES
    ('José Carlos', '456.123.789-00', 'Avenida Brasil', '780', 'Bloco B, Apto 12', 'Vila Carvalho', 'Sorocaba', 'SP', '18060-150');

INSERT INTO pessoa
    (nome, documento, logradouro, numero, complemento, bairro, cidade, estado, cep)
VALUES
    ('Gabriel Felipe', '901.123.789-00', 'Rua das Palmeiras', '56', 'Casa', 'Jardim Simus', 'Sorocaba', 'SP', '18055-310');

-- ── 2. INSERT em FUNCIONARIO ─────────────────────────────────
-- Vincular funcionários a códigos de pessoas já existentes.

INSERT INTO funcionario
    (codigo, registro_funcional, data_admissao, setor_lotacao)
VALUES
    (1, 'RF123456789', '2026-01-01', 'TI');

INSERT INTO funcionario
    (codigo, registro_funcional, data_admissao, setor_lotacao)
VALUES
    (4, 'RF123456710', '2026-01-01', 'TI');

-- ── 3. INSERT em ESTUDANTE ───────────────────────────────────
-- Cadastrar estudantes apontando para código de pessoa.
-- Incluir estudantes com orientador (id_orientador) e sem orientador (NULL).

INSERT INTO estudante
    (codigo, matricula, curso, id_orientador)
VALUES
    (1, '202600123', 'Análise e Desenvolvimento de Sistemas', NULL);

INSERT INTO estudante
    (codigo, matricula, curso, id_orientador)
VALUES
    (2, '202600124', 'Análise e Desenvolvimento de Sistemas', 1);

INSERT INTO estudante
    (codigo, matricula, curso, id_orientador)
VALUES
    (3, '202600125', 'Análise e Desenvolvimento de Sistemas', NULL);

INSERT INTO estudante
    (codigo, matricula, curso, id_orientador)
VALUES
    (4, '202600126', 'Análise e Desenvolvimento de Sistemas', NULL);

-- ── 4. Especialização Sobreposta (Estudante E Funcionário) ────
-- Demonstrar a inserção de uma mesma pessoa em FUNCIONARIO e ESTUDANTE.

SELECT
    pessoa.nome,
    funcionario.registro_funcional,
    estudante.matricula,
    estudante.curso
FROM pessoa
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo;


-- ── 5. INSERT em DISCIPLINA ───────────────────────────────────
-- Cadastrar disciplinas com código alfanumérico (ex: 'CC001') e carga horária.

INSERT INTO disciplina 
    (codigo, nome, carga_horaria)
VALUES
    ('123', 'BD01', 100);

INSERT INTO disciplina 
    (codigo, nome, carga_horaria)
VALUES
    ('456', 'DWEB02', 80);

INSERT INTO disciplina 
    (codigo, nome, carga_horaria)
VALUES
    ('789', 'LP03', 60);

-- ── 6. INSERT em MINISTRA ────────────────────────────────────
-- Associar docentes a disciplinas.
-- Demonstrar uma disciplina ministrada por mais de um docente.

INSERT INTO ministra
    (id_funcionario, disciplina_codigo)
VALUES
    (1, '123');

INSERT INTO ministra
    (id_funcionario, disciplina_codigo)
VALUES
    (1, '456');

INSERT INTO ministra
    (id_funcionario, disciplina_codigo)
VALUES
    (1, '789');

INSERT INTO ministra
    (id_funcionario, disciplina_codigo)
VALUES
    (4, '123');

-- ── 7. INSERT em MATRICULA_DISCIPLINA ─────────────────────────
-- Matricular estudantes em disciplinas (com semestre, ano e nota final).

INSERT INTO matricula_disciplina
    (id_estudante, disciplina_codigo, semestre, ano, nota_final)
VALUES
    (2, '456', 1, 2026, 10);

INSERT INTO matricula_disciplina
    (id_estudante, disciplina_codigo, semestre, ano, nota_final)
VALUES
    (3, '789', 2, 2026, 9);

INSERT INTO matricula_disciplina
    (id_estudante, disciplina_codigo, semestre, ano, nota_final)
VALUES
    (1, '123', 2, 2026, 10);


-- 8. INSERT em ORIENTACAO

INSERT INTO orientacao
    (id_funcionario, id_estudante)
VALUES
    (1, 2);

-- ── 9. UPDATE ─────────────────────────────────────────────────
-- Exercícios:
-- a) Lançar ou alterar a nota de um estudante.
-- b) Atribuir ou trocar o orientador de um estudante.
-- c) Atualizar endereço de uma pessoa.

UPDATE matricula_disciplina
SET nota_final = 8.5
WHERE 
    id_estudante = 2
    AND disciplina_codigo = '456'
    AND semestre = 1
    AND ano = 2026;

UPDATE estudante
SET id_orientador = 1
WHERE codigo = 3;

UPDATE pessoa
SET cidade = 'Votorantim'
WHERE
    nome = 'Maria Silva' 
    AND documento = '987.654.321-00' 
    AND estado = 'SP';

-- ── 10. DELETE ─────────────────────────────────────────────────
-- Exercícios:
-- a) Remover uma matrícula específica em disciplina.
-- b) Testar remoção com integridade referencial (ON DELETE CASCADE).

DELETE FROM matricula_disciplina
WHERE
    id_estudante = 2
    AND disciplina_codigo = '456'
    AND semestre = 1
    AND ano = 2026;

-- Testar ON DELETE CASCADE

DELETE FROM ministra
WHERE id_funcionario = 4;

DELETE FROM pessoa
WHERE codigo = 4;

--Verificar
SELECT * FROM pessoa WHERE codigo = 4;
SELECT * FROM funcionario WHERE codigo = 4;