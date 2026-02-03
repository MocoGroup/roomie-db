CREATE TABLE usuario(
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    genero VARCHAR(20)
);

CREATE TABLE estudante(
    id_estudante INT NOT NULL,
    curso VARCHAR(100) NOT NULL,
    instituicao VARCHAR(100) NOT NULL,

    PRIMARY KEY (id_estudante),
    CONSTRAINT fk_estudante_usuario 
        FOREIGN KEY (id_estudante)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE telefone(
    id_telefone SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    numero VARCHAR(20) NOT NULL,

    CONSTRAINT fk_usuario_telefone
        FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE habito(
    id_habito SERIAL PRIMARY KEY,
    id_estudante INT NOT NULL,
    horario_estudo VARCHAR(100),
    estilo_vida VARCHAR(100),
    preferencia_limpeza VARCHAR(100),
    hobbies TEXT,

    CONSTRAINT fk_habito_estudante
        FOREIGN KEY (id_estudante) 
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE
);

CREATE TABLE imovel(
    id_imovel SERIAL PRIMARY KEY,
    id_proprietario INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    genero_moradores VARCHAR(20),
    aceita_animais BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_imovel_proprietario
        FOREIGN KEY (id_proprietario) 
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL UNIQUE,
    rua VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(20) NOT NULL,

    CONSTRAINT fk_endereco_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE
);

CREATE TABLE foto_imovel (
    id_imagem SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL,
    caminho_imagem VARCHAR(255) NOT NULL,

    CONSTRAINT fk_foto_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE
);

CREATE TABLE contrato_locacao(
    id_contrato SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL,
    id_estudante INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_aluguel DECIMAL(10, 2) NOT NULL,

    CONSTRAINT fk_contrato_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE,

    CONSTRAINT fk_contrato_estudante
        FOREIGN KEY (id_estudante) 
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE
);

CREATE TABLE avaliacao_imovel(
    id_avaliacao SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL,
    id_estudante INT NOT NULL,
    nota INT CHECK (nota >= 1 AND nota <= 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_avaliacao_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE,

    CONSTRAINT fk_avaliacao_estudante
        FOREIGN KEY (id_estudante) 
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE
);

CREATE TABLE chat(
    id_chat SERIAL PRIMARY KEY,
    id_estudante INT NOT NULL,
    id_proprietario INT NOT NULL,
    id_imovel INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_chat_estudante
        FOREIGN KEY (id_estudante)
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE,

    CONSTRAINT fk_chat_proprietario
        FOREIGN KEY (id_proprietario)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE,
    
    CONSTRAINT fk_chat_imovel
        FOREIGN KEY (id_imovel)
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE
);

CREATE TABLE mensagem(
    id_mensagem SERIAL PRIMARY KEY,
    id_chat INT NOT NULL,
    id_remetente INT NOT NULL,
    conteudo TEXT NOT NULL,
    timestamp_mensagem TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_mensagem_chat
        FOREIGN KEY (id_chat)
        REFERENCES chat(id_chat)
        ON DELETE CASCADE,

    CONSTRAINT fk_mensagem_remetente
        FOREIGN KEY (id_remetente)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);