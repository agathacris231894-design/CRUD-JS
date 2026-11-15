-- ================================================================
-- DQL.sql — Data Query Language
-- Universidade Comunitária
-- ================================================================
-- Construído em aula com os alunos.
--
-- COMANDOS: SELECT (com JOIN, WHERE, GROUP BY, HAVING, ORDER BY)
-- ================================================================


-- ── 1. Listar todas as pessoas com endereço completo formatado 

SELECT
    pessoa.nome,
    pessoa.documento,
    pessoa.logradouro || ', ' || 
    pessoa.numero || ', ' || 
    COALESCE(pessoa.complemento, '') || ', ' || 
    pessoa.bairro || ', ' ||
    pessoa.cidade || ' - ' || 
    pessoa.estado || ' - ' || 
    pessoa.cep AS endereco
FROM pessoa;

-- Resultado esperado da consulta de pessoas com endereço completo:

-- | nome            | documento      | endereco                                                                        |
-- | :-------------- | :------------- | :------------------------------------------------------------------------------ |
-- | Agatha Cristina | 123.456.789-10 | Rua das Margaridas, 123, APT 1, Centro, Sorocaba - SP - 12345-678               |
-- | Maria Silva     | 987.654.321-00 | Rua das Acácias, 245, Casa 2, Jardim Europa, Sorocaba - SP - 18045-120          |
-- | José Carlos     | 456.123.789-00 | Avenida Brasil, 780, Bloco B, Apto 12, Vila Carvalho, Sorocaba - SP - 18060-150 |
-- | Gabriel Felipe  | 901.123.789-00 | Rua das Palmeiras, 56, Casa, Jardim Simus, Sorocaba - SP - 18055-310            |

-- ── 2. Listar todos os estudantes com dados pessoais (JOIN com PESSOA) 

SELECT
    pessoa.nome,
    estudante.curso
FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo;

-- Resultado esperado da consulta de estudantes com seus respectivos cursos:
--
-- | nome            | curso                                  |
-- | :-------------- | :------------------------------------- |
-- | Agatha Cristina | Análise e Desenvolvimento de Sistemas  |
-- | Maria Silva     | Análise e Desenvolvimento de Sistemas  |
-- | José Carlos     | Análise e Desenvolvimento de Sistemas  |
-- | Gabriel Felipe  | Análise e Desenvolvimento de Sistemas  |

-- ── 3. Listar todos os funcionários com setor e data de admissão 

SELECT 
    pessoa.nome,
    funcionario.setor_lotacao,
    funcionario.data_admissao
FROM pessoa
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo;

-- Resultado esperado da consulta de funcionários com setor e data de admissão:
--
-- | nome            | setor_lotacao | data_admissao |
-- | :-------------- | :------------ | :------------ |
-- | Agatha Cristina | TI            | 2026-01-01    |
-- | Gabriel Felipe  | TI            | 2026-01-01    |

-- ── 4. Pessoas que são Estudante E Funcionário (Especialização Sobreposta) 

SELECT 
    pessoa.nome,
    pessoa.documento
FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo;

-- Resultado esperado da consulta de pessoas que são estudantes E funcionários:
--
-- | nome            | documento      |
-- | :-------------- | :------------- |
-- | Agatha Cristina | 123.456.789-10 |
-- | Gabriel Felipe  | 901.123.789-00 |

-- ── 5. Disciplinas com carga horária >= 60 horas ───────────────

SELECT 
    disciplina.codigo, 
    disciplina.nome, 
    disciplina.carga_horaria
FROM disciplina
WHERE carga_horaria >= 60;

-- Resultado esperado da consulta de disciplinas com carga horária maior ou igual a 60 horas:
--
-- | codigo | nome   | carga_horaria |
-- | :----- | :----- | :------------ |
-- | 123    | BD01   | 100           |
-- | 456    | DWEB02 | 80            |
-- | 789    | LP03   | 60            |

-- ── 6. Estudantes matriculados em uma disciplina específica (ex: 'CC001') 

SELECT 
    pessoa.nome, 
    estudante.matricula, 
    disciplina.nome
FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo
INNER JOIN matricula_disciplina
    ON estudante.codigo = matricula_disciplina.id_estudante
INNER JOIN disciplina
    ON matricula_disciplina.disciplina_codigo = disciplina.codigo
WHERE disciplina.codigo = 'CC001';

--Resultado esperado da consulta

-- Query executada — 0 linhas retornadas

-- ── 7. Histórico escolar: notas de cada estudante por disciplina e ano (com CASE WHEN) 

SELECT
    pessoa.nome AS estudante,
    estudante.matricula,
    disciplina.nome AS disciplina,
    matricula_disciplina.ano,
CASE
    WHEN matricula_disciplina.nota_final >= 6 THEN 'Aprovado'
    WHEN matricula_disciplina.nota_final >= 4 THEN 'Recuperação'
    WHEN matricula_disciplina.nota_final IS NULL THEN 'Sem nota'
    ELSE 'Reprovado'
END AS situacao

FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo
INNER JOIN matricula_disciplina
    ON estudante.codigo = matricula_disciplina.id_estudante
INNER JOIN disciplina
    ON matricula_disciplina.disciplina_codigo = disciplina.codigo;

-- Resultado esperado da consulta de histórico escolar com a situação dos estudantes:
--
-- | estudante       | matricula | disciplina | ano  | situacao |
-- | :-------------- | :-------- | :--------- | :--- | :------- |
-- | Maria Silva     | 202600124 | DWEB02     | 2026 | Aprovado |
-- | José Carlos     | 202600125 | LP03       | 2026 | Aprovado |
-- | Agatha Cristina | 202600123 | BD01       | 2026 | Aprovado |

-- ── 8. Funcionários e as disciplinas que ministram (N:M) ───────

SELECT
    pessoa.nome AS funcionario,
    funcionario.registro_funcional,
    disciplina.nome AS disciplina
FROM pessoa
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo
INNER JOIN ministra
    ON funcionario.codigo = ministra.id_funcionario
INNER JOIN disciplina
    ON ministra.disciplina_codigo = disciplina.codigo;

-- Resultado esperado da consulta de funcionários e disciplinas que ministram:
--
-- | funcionario     | registro_funcional | disciplina |
-- | :-------------- | :----------------- | :--------- |
-- | Agatha Cristina | RF123456789        | BD01       |
-- | Agatha Cristina | RF123456789        | DWEB02     |
-- | Agatha Cristina | RF123456789        | LP03       |
-- | Gabriel Felipe  | RF123456710        | BD01       |

-- ── 9. Orientadores e seus orientados (Autorrelacionamento via FUNCIONARIO) 

SELECT
    p_estudante.nome AS estudante,
    estudante.matricula,
    p_orientador.nome AS orientador
FROM pessoa AS p_estudante
INNER JOIN estudante
    ON p_estudante.codigo = estudante.codigo
INNER JOIN orientacao
    ON estudante.codigo = orientacao.id_estudante
INNER JOIN funcionario
    ON orientacao.id_funcionario = funcionario.codigo
INNER JOIN pessoa AS p_orientador
    ON funcionario.codigo = p_orientador.codigo;

-- Resultado esperado da consulta de orientadores e seus orientados:
--
-- | estudante   | matricula | orientador      |
-- | :---------- | :-------- | :-------------- |
-- | Maria Silva | 202600124 | Agatha Cristina |

-- ── 10. Estudantes que ainda NÃO possuem orientador (IS NULL) ──

SELECT
    p_estudante.nome AS estudante,
    estudante.matricula
FROM pessoa AS p_estudante
INNER JOIN estudante
    ON p_estudante.codigo = estudante.codigo
LEFT JOIN orientacao
    ON estudante.codigo = orientacao.id_estudante
WHERE orientacao.id_funcionario IS NULL;

-- Resultado esperado da consulta de estudantes que ainda NÃO possuem orientador:
--
-- | estudante       | matricula |
-- | :-------------- | :-------- |
-- | Agatha Cristina | 202600123 |
-- | José Carlos     | 202600125 |
-- | Gabriel Felipe  | 202600126 |

-- ── 11. Média de notas por disciplina (COUNT, AVG, MIN, MAX e GROUP BY) 

SELECT
    disciplina.nome,
    COUNT(matricula_disciplina.nota_final) AS quantidade_notas,
    AVG(matricula_disciplina.nota_final) AS media,
    MIN(matricula_disciplina.nota_final) AS menor_nota,
    MAX(matricula_disciplina.nota_final) AS maior_nota
FROM disciplina
INNER JOIN matricula_disciplina
    ON disciplina.codigo = matricula_disciplina.disciplina_codigo
GROUP BY disciplina.nome;

-- Resultado esperado da consulta de notas agrupadas por disciplina:
--
-- | nome   | quantidade_notas | media | menor_nota | maior_nota |
-- | :----- | :--------------- | :---- | :--------- | :--------- |
-- | BD01   | 1                | 10    | 10         | 10         |
-- | DWEB02 | 1                | 10    | 10         | 10         |
-- | LP03   | 1                | 9     | 9          | 9          |

-- ── 12. Estudantes aprovados (nota >= 6.0) em cada disciplina ──

SELECT
    pessoa.nome AS estudante,
    estudante.matricula,
    matricula_disciplina.nota_final,
    disciplina.nome AS disciplina
FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo
INNER JOIN matricula_disciplina
    ON estudante.codigo = matricula_disciplina.id_estudante
INNER JOIN disciplina
    ON matricula_disciplina.disciplina_codigo = disciplina.codigo
WHERE matricula_disciplina.nota_final >= 6.0;

-- Resultado esperado:
--
-- | estudante       | matricula | nota_final | disciplina |
-- | :-------------- | :-------- | :--------- | :--------- |
-- | Maria Silva     | 202600124 | 10         | DWEB02     |
-- | José Carlos     | 202600125 | 9          | LP03       |
-- | Agatha Cristina | 202600123 | 10         | BD01       |

-- ── 13. Quantidade de orientandos por funcionário (GROUP BY) ───

SELECT
    pessoa.nome,
    funcionario.registro_funcional,
    COUNT(orientacao.id_estudante) AS quantidade_orientandos
FROM pessoa
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo
LEFT JOIN orientacao
    ON funcionario.codigo = orientacao.id_funcionario
GROUP BY pessoa.nome, funcionario.registro_funcional;

-- Resultado esperado:
--
-- | nome            | registro_funcional | quantidade_orientandos |
-- | :-------------- | :----------------- | :--------------------- |
-- | Agatha Cristina | RF123456789        | 1                      |
-- | Gabriel Felipe  | RF123456710        | 0                      |

-- ── 14. Todos os estudantes e seus orientadores (LEFT JOIN e COALESCE) 

SELECT
    p_estudante.nome AS estudante,
    estudante.matricula,
    COALESCE(p_orientador.nome, 'Sem orientador') AS orientador

FROM pessoa AS p_estudante

INNER JOIN estudante
    ON p_estudante.codigo = estudante.codigo

LEFT JOIN orientacao
    ON estudante.codigo = orientacao.id_estudante

LEFT JOIN funcionario
    ON orientacao.id_funcionario = funcionario.codigo

LEFT JOIN pessoa AS p_orientador
    ON funcionario.codigo = p_orientador.codigo;

-- Resultado esperado:
--
-- | estudante       | matricula | orientador      |
-- | :-------------- | :-------- | :-------------- |
-- | Agatha Cristina | 202600123 | Sem orientador  |
-- | Maria Silva     | 202600124 | Agatha Cristina |
-- | José Carlos     | 202600125 | Sem orientador  |
-- | Gabriel Felipe  | 202600126 | Sem orientador  |

-- ── 15. Total de disciplinas e carga horária ministrada por docente 

SELECT
    pessoa.nome,
    funcionario.registro_funcional,
    COUNT(disciplina.codigo) AS quantidade_disciplinas,
    SUM(disciplina.carga_horaria) AS total_horas
FROM pessoa
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo
INNER JOIN ministra
    ON funcionario.codigo = ministra.id_funcionario
INNER JOIN disciplina
    ON ministra.disciplina_codigo = disciplina.codigo
GROUP BY pessoa.nome, funcionario.registro_funcional;

-- Resultado esperado:
--
-- | nome            | registro_funcional | quantidade_disciplinas | total_horas |
-- | :-------------- | :----------------- | :--------------------- | :---------- |
-- | Agatha Cristina | RF123456789        | 3                      | 240         |
-- | Gabriel Felipe  | RF123456710        | 1                      | 100         |

-- ── Exercícios que eu fiz a mais da outra lista


-- ── 16. Listar todas as pessoas (nome + documento) ─────────────

SELECT nome, documento
FROM pessoa;

-- Resultado esperado:
--
-- | nome            | documento      |
-- | :-------------- | :------------- |
-- | Agatha Cristina | 123.456.789-10 |
-- | Maria Silva     | 987.654.321-00 |
-- | José Carlos     | 456.123.789-00 |
-- | Gabriel Felipe  | 901.123.789-00 |

-- ── 17. Disciplinas com carga horária > X horas ────────────────

SELECT codigo, nome, carga_horaria
FROM disciplina
WHERE carga_horaria > 70;

-- Resultado esperado:
--
-- | codigo | nome   | carga_horaria |
-- | :----- | :----- | :------------ |
-- | 123    | BD01   | 100           |
-- | 456    | DWEB02 | 80            |

-- ── 18. Estudantes matriculados em uma disciplina específica ───

SELECT
    pessoa.nome,
    estudante.matricula,
    disciplina.nome
FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo
INNER JOIN matricula_disciplina
    ON estudante.codigo = matricula_disciplina.id_estudante
INNER JOIN disciplina
    ON matricula_disciplina.disciplina_codigo = disciplina.codigo
WHERE disciplina.nome = 'BD01';

-- Resultado esperado:
--
-- | nome            | matricula | nome |
-- | :-------------- | :-------- | :--- |
-- | Agatha Cristina | 202600123 | BD01 |

-- ── 19. Nota final de cada estudante por disciplina e ano ──────

SELECT
    pessoa.nome AS estudante,
    estudante.matricula,
    disciplina.nome AS disciplina,
    matricula_disciplina.ano,
    matricula_disciplina.nota_final
FROM pessoa
INNER JOIN estudante
    ON pessoa.codigo = estudante.codigo
INNER JOIN matricula_disciplina
    ON estudante.codigo = matricula_disciplina.id_estudante
INNER JOIN disciplina
    ON matricula_disciplina.disciplina_codigo = disciplina.codigo;

-- Resultado esperado:
--
-- | estudante       | matricula | disciplina | ano  | nota_final |
-- | :-------------- | :-------- | :--------- | :--- | :--------- |
-- | Maria Silva     | 202600124 | DWEB02     | 2026 | 10         |
-- | José Carlos     | 202600125 | LP03       | 2026 | 9          |
-- | Agatha Cristina | 202600123 | BD01       | 2026 | 10         |

-- ── 20. Funcionário com mais disciplinas ministradas ──────────

SELECT
    pessoa.nome,
    funcionario.registro_funcional,
    COUNT(ministra.disciplina_codigo) AS quantidade_disciplinas
FROM pessoa
INNER JOIN funcionario
    ON pessoa.codigo = funcionario.codigo
INNER JOIN ministra
    ON funcionario.codigo = ministra.id_funcionario
GROUP BY pessoa.nome, funcionario.registro_funcional
ORDER BY quantidade_disciplinas DESC
LIMIT 1;

-- Resultado esperado:
--
-- | nome            | registro_funcional | quantidade_disciplinas |
-- | :-------------- | :----------------- | :--------------------- |
-- | Agatha Cristina | RF123456789        | 3                      |

-- ── 21. Estudantes e seus orientadores (LEFT JOIN) ────────────

SELECT
    p_estudante.nome AS estudante,
    estudante.matricula,
    p_orientador.nome AS orientador

FROM pessoa AS p_estudante
INNER JOIN estudante
    ON p_estudante.codigo = estudante.codigo
LEFT JOIN orientacao
    ON estudante.codigo = orientacao.id_estudante
LEFT JOIN funcionario
    ON orientacao.id_funcionario = funcionario.codigo
LEFT JOIN pessoa AS p_orientador
    ON funcionario.codigo = p_orientador.codigo;

-- Resultado esperado:
--
-- | estudante       | matricula | orientador      |
-- | :-------------- | :-------- | :-------------- |
-- | Agatha Cristina | 202600123 | NULL            |
-- | Maria Silva     | 202600124 | Agatha Cristina |
-- | José Carlos     | 202600125 | NULL            |
-- | Gabriel Felipe  | 202600126 | NULL            |