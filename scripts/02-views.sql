CREATE VIEW v_detalhes_imovel AS
SELECT
    i.id_imovel,
    i.titulo,
    i.descricao,
    i.tipo,
    i.preco,
    i.genero_moradores,
    i.aceita_animais,
    i.tem_garagem,
    i.vagas_disponiveis,
    i.status,
    e.rua,
    e.numero AS num_endereco,
    e.bairro,
    e.cidade,
    e.estado,
    e.cep,
    u.nome  AS nome_proprietario,
    u.email AS email_proprietario
FROM imovel i
INNER JOIN endereco e ON i.id_imovel       = e.id_imovel
INNER JOIN usuario u  ON i.id_proprietario = u.id_usuario;


CREATE VIEW v_perfil_estudante_contato AS
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    u.genero,
    est.curso,
    est.instituicao,
    STRING_AGG(t.numero, ', ') AS telefones
FROM estudante est
INNER JOIN usuario  u ON est.id_estudante = u.id_usuario
LEFT  JOIN telefone t ON u.id_usuario     = t.id_usuario
GROUP BY
    u.id_usuario,
    u.nome,
    u.email,
    u.genero,
    est.curso,
    est.instituicao;


CREATE VIEW v_relatorio_proprietario AS
SELECT
    u.id_usuario         AS id_proprietario,
    u.nome               AS nome_proprietario,
    u.email              AS email_proprietario,
    COUNT(i.id_imovel)           AS total_imoveis,
    SUM(i.vagas_disponiveis)     AS total_vagas_oferecidas,
    ROUND(AVG(i.preco), 2)       AS media_preco_imoveis,
    MIN(i.preco)                 AS menor_preco,
    MAX(i.preco)                 AS maior_preco
FROM usuario u
INNER JOIN imovel i ON u.id_usuario = i.id_proprietario
GROUP BY
    u.id_usuario,
    u.nome,
    u.email;


CREATE VIEW v_ranking_imoveis_avaliados AS
SELECT
    i.id_imovel,
    i.titulo,
    i.tipo,
    i.preco,
    i.status,
    e.cidade,
    e.bairro,
    u.nome                           AS nome_proprietario,
    COUNT(a.id_avaliacao)            AS total_avaliacoes,
    ROUND(AVG(a.nota)::NUMERIC, 2)   AS media_nota,
    MIN(a.nota)                      AS pior_nota,
    MAX(a.nota)                      AS melhor_nota
FROM imovel i
INNER JOIN endereco e         ON i.id_imovel       = e.id_imovel
INNER JOIN usuario u          ON i.id_proprietario = u.id_usuario
LEFT  JOIN avaliacao_imovel a ON i.id_imovel       = a.id_imovel
GROUP BY
    i.id_imovel, i.titulo, i.tipo, i.preco, i.status,
    e.cidade, e.bairro, u.nome
ORDER BY media_nota DESC NULLS LAST;


CREATE VIEW v_engajamento_estudante AS
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    est.curso,
    est.instituicao,
    COUNT(DISTINCT int2.id_interesse)   AS total_interesses,
    COUNT(DISTINCT c.id_contrato)       AS total_contratos,
    COUNT(DISTINCT av.id_avaliacao)     AS total_avaliacoes_feitas,
    ROUND(AVG(av.nota)::NUMERIC, 2)     AS media_nota_dada
FROM estudante est
INNER JOIN usuario          u     ON est.id_estudante = u.id_usuario
LEFT  JOIN interesse        int2  ON est.id_estudante = int2.id_estudante
LEFT  JOIN contrato_locacao c     ON est.id_estudante = c.id_estudante
LEFT  JOIN avaliacao_imovel av    ON est.id_estudante = av.id_estudante
GROUP BY
    u.id_usuario, u.nome, u.email, est.curso, est.instituicao;
