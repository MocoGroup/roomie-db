-- POVOAMENTO CONTROLADO - CENÁRIO DE TESTE
-- HISTÓRIA: ANA (ESTUDANTE) ALUGANDO UM QUARTO DO CARLOS (PROPRIETÁRIO)

INSERT INTO usuario (nome, email, senha, genero) VALUES
('Carlos Proprietário', 'carlos@roomie.com', '123456', 'Masculino'),
('Ana Estudante', 'ana@ufape.edu.br', '123456', 'Feminino'),
('Marcos Calouro', 'marcos@ufape.edu.br', '123456', 'Masculino');

INSERT INTO estudante (id_estudante, curso, instituicao) VALUES
(2, 'Ciência da Computação', 'UFAPE'),
(3, 'Agronomia', 'UFAPE');

INSERT INTO telefone (id_usuario, numero) VALUES
(1, '(87) 99999-0001'),
(2, '(87) 99999-0002'),
(3, '(87) 99999-0003');

INSERT INTO habito (id_estudante, horario_estudo, estilo_vida, preferencia_limpeza, hobbies) VALUES
(2, 'Noite', 'Calmo', 'Alto', 'Programação e leitura'),
(3, 'Dia', 'Agitado', 'Médio', 'Esportes e música');

INSERT INTO imovel (id_proprietario, titulo, descricao, tipo, preco, genero_moradores, aceita_animais) VALUES
(1, 'Suíte confortável próximo à UFAPE', 'Quarto com banheiro privativo, internet inclusa.', 'Quarto', 600.00, 'Feminino', TRUE),
(1, 'Casa inteira no Aluísio', 'Casa com 3 quartos, ideal para estudantes, internet e energia inclusa.', 'Casa', 1000.00, 'Indiferente', FALSE);

INSERT INTO endereco (id_imovel, rua, bairro, numero, cidade, estado, cep) VALUES
(1, 'Rua Deocleciano Soares da Rocha', 'Boa Vista', '123', 'Garanhuns', 'Pernambuco', '55292-760'),
(2, 'Rua Luís Gama', 'Aluísio', '32', 'Garanhuns', 'Pernambuco', '55292-045');

INSERT INTO foto_imovel (id_imovel, caminho_imagem) VALUES
(1, '/imagens/quartos/suite_01.jpg'),
(1, '/imagens/quartos/suite_02.jpg'),
(2, '/imagens/casas/frente_casa.jpg');

INSERT INTO chat (id_estudante, id_proprietario, id_imovel) VALUES
(2, 1, 1);

INSERT INTO mensagem (id_chat, id_remetente, conteudo) VALUES
(1, 2, 'Olá Carlos, estou interessada na suíte que você anunciou. Podemos conversar mais sobre ela?'),
(1, 1, 'Olá Ana! Claro, a suíte está disponível e é perfeita para estudantes. Você gostaria de agendar uma visita?'),
(1, 2, 'Sim, adoraria agendar uma visita. Quando seria um bom momento para você?'),
(1, 1, 'Que tal amanhã à tarde? Estou disponível a partir das 14h.'),
(1, 2, 'Perfeito! Nos vemos amanhã às 14h então. Obrigada!'),
(1, 1, 'Ótimo! Até amanhã, Ana.');

INSERT INTO contrato_locacao (id_imovel, id_estudante, data_inicio, data_fim, valor_aluguel) VALUES
(1, 2, '2026-03-01', '2026-09-01', 600.00);

INSERT INTO avaliacao_imovel (id_imovel, id_estudante, nota, comentario) VALUES
(1, 2, 5, 'Excelente apartamento, muito confortável e bem localizado. Recomendo!');
