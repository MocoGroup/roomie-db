CREATE TYPE horarios AS ENUM ('MORNING', 'AFTERNOON', 'EVENING', 'DAWN');
CREATE TYPE tipo_genero AS ENUM ('MALE', 'FEMALE', 'OTHER', 'MIXED');
CREATE TYPE status_contrato AS ENUM ('ACTIVE', 'FINISHED', 'CANCELLED'); 
CREATE TYPE user_role AS ENUM ('ADMIN', 'USER');
CREATE TYPE tipo_imovel AS ENUM ('HOUSE', 'APARTMENT', 'STUDIO', 'ROOM', 'DORMITORY');
CREATE TYPE status_anuncio AS ENUM ('DRAFT', 'ACTIVE', 'RENTED');
CREATE TYPE status_interesse AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED');

CREATE TABLE usuario(
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    genero tipo_genero,
    cargo user_role NOT NULL DEFAULT 'USER'
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
    horario_estudo horarios,
    CONSTRAINT fk_habito_estudante
        FOREIGN KEY (id_estudante) 
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE
);

CREATE TABLE estilo_vida(
    id_estilo SERIAL PRIMARY KEY,
    id_habito INT NOT NULL,
    estilo VARCHAR(100) NOT NULL,
    CONSTRAINT fk_estilo_habito
        FOREIGN KEY (id_habito)
            REFERENCES habito(id_habito)
            ON DELETE CASCADE
);

CREATE TABLE preferencia_limpeza(
    id_preferencia SERIAL PRIMARY KEY,
    id_habito INT NOT NULL,
    preferencia VARCHAR(100) NOT NULL,
    CONSTRAINT fk_preferencia_habito
        FOREIGN KEY (id_habito)
            REFERENCES habito(id_habito)
            ON DELETE CASCADE
);

CREATE TABLE hobby(
    id_hobby SERIAL PRIMARY KEY,
    id_habito INT NOT NULL,
    hobby VARCHAR(100) NOT NULL,
    CONSTRAINT fk_hobby_habito
        FOREIGN KEY (id_habito)
            REFERENCES habito(id_habito)
            ON DELETE CASCADE
);

CREATE TABLE imovel(
    id_imovel SERIAL PRIMARY KEY,
    id_proprietario INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo tipo_imovel NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    genero_moradores tipo_genero NOT NULL,
    aceita_animais BOOLEAN DEFAULT FALSE,
    tem_garagem BOOLEAN DEFAULT FALSE,
    vagas_disponiveis INT NOT NULL DEFAULT 1,
    status status_anuncio NOT NULL DEFAULT 'DRAFT',  

    CONSTRAINT fk_imovel_proprietario
        FOREIGN KEY (id_proprietario) 
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);

CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL UNIQUE,
    rua VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(20) NOT NULL,

    CONSTRAINT fk_endereco_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE
);

CREATE TABLE imagem_imovel (
    id_imagem SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL,
    caminho_imagem VARCHAR(255) NOT NULL,

    CONSTRAINT fk_imagem_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE
);

CREATE TABLE contrato_locacao(
    id_contrato SERIAL PRIMARY KEY,
    id_imovel INT NOT NULL,
    id_estudante INT NOT NULL,
    id_proprietario INT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    valor_aluguel DECIMAL(10, 2) NOT NULL,
    status_contrato status_contrato NOT NULL,

    CONSTRAINT fk_contrato_imovel
        FOREIGN KEY (id_imovel) 
        REFERENCES imovel(id_imovel)
        ON DELETE CASCADE,

    CONSTRAINT fk_contrato_estudante
        FOREIGN KEY (id_estudante) 
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE,

    CONSTRAINT ck_datas_validas CHECK (data_fim > data_inicio),
    
    CONSTRAINT fk_contrato_proprietario
        FOREIGN KEY (id_proprietario) 
        REFERENCES usuario(id_usuario)
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

CREATE TABLE interesse(
    id_interesse SERIAL PRIMARY KEY,
    id_estudante INT NOT NULL,
    id_imovel INT NOT NULL,
    data_interesse TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status status_interesse NOT NULL DEFAULT 'PENDING',

    CONSTRAINT fk_interesse_estudante
        FOREIGN KEY (id_estudante)
        REFERENCES estudante(id_estudante)
        ON DELETE CASCADE,

    CONSTRAINT fk_interesse_imovel
        FOREIGN KEY (id_imovel)
        REFERENCES imovel(id_imovel)
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
    lida BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_mensagem_chat
        FOREIGN KEY (id_chat)
        REFERENCES chat(id_chat)
        ON DELETE CASCADE,

    CONSTRAINT fk_mensagem_remetente
        FOREIGN KEY (id_remetente)
        REFERENCES usuario(id_usuario)
        ON DELETE CASCADE
);