CREATE DATABASE IF NOT EXISTS skillmatch CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE skillmatch;

DROP TABLE IF EXISTS candidatura, trilha_curso, trilha_aprendizado, curso_habilidade,
curso, vaga_habilidade, vaga, usuario_habilidade, habilidade, experiencia,
objetivo_profissional, usuario;

CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    cidade VARCHAR(100),
    estado CHAR(2),
    resumo TEXT,
    foto VARCHAR(255),
    tipo ENUM('candidato','admin') DEFAULT 'candidato',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE habilidade (
    id_habilidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL UNIQUE,
    categoria VARCHAR(80) NOT NULL,
    descricao TEXT
);

CREATE TABLE usuario_habilidade (
    id_usuario INT NOT NULL,
    id_habilidade INT NOT NULL,
    nivel ENUM('basico','intermediario','avancado','especialista') DEFAULT 'basico',
    anos_experiencia DECIMAL(4,1) DEFAULT 0,
    PRIMARY KEY (id_usuario, id_habilidade),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_habilidade) REFERENCES habilidade(id_habilidade) ON DELETE CASCADE
);

CREATE TABLE experiencia (
    id_experiencia INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    empresa VARCHAR(150) NOT NULL,
    cargo VARCHAR(120) NOT NULL,
    data_inicio DATE,
    data_fim DATE,
    atual BOOLEAN DEFAULT FALSE,
    descricao TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE objetivo_profissional (
    id_objetivo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    cargo_desejado VARCHAR(120) NOT NULL,
    area VARCHAR(100),
    nivel ENUM('estagio','junior','pleno','senior','lideranca') DEFAULT 'junior',
    descricao TEXT,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE vaga (
    id_vaga INT AUTO_INCREMENT PRIMARY KEY,
    empresa VARCHAR(150) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    area VARCHAR(100),
    nivel ENUM('estagio','junior','pleno','senior','lideranca') DEFAULT 'junior',
    localizacao VARCHAR(150),
    modalidade ENUM('presencial','hibrido','remoto') DEFAULT 'hibrido',
    salario_min DECIMAL(10,2),
    salario_max DECIMAL(10,2),
    descricao TEXT,
    requisitos TEXT,
    ativa BOOLEAN DEFAULT TRUE,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vaga_habilidade (
    id_vaga INT NOT NULL,
    id_habilidade INT NOT NULL,
    nivel_minimo ENUM('basico','intermediario','avancado','especialista') DEFAULT 'basico',
    obrigatoria BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id_vaga, id_habilidade),
    FOREIGN KEY (id_vaga) REFERENCES vaga(id_vaga) ON DELETE CASCADE,
    FOREIGN KEY (id_habilidade) REFERENCES habilidade(id_habilidade) ON DELETE CASCADE
);

CREATE TABLE curso (
    id_curso INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(180) NOT NULL,
    plataforma VARCHAR(100),
    url VARCHAR(255),
    carga_horaria INT,
    nivel ENUM('iniciante','intermediario','avancado') DEFAULT 'iniciante',
    descricao TEXT
);

CREATE TABLE curso_habilidade (
    id_curso INT NOT NULL,
    id_habilidade INT NOT NULL,
    PRIMARY KEY (id_curso, id_habilidade),
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE,
    FOREIGN KEY (id_habilidade) REFERENCES habilidade(id_habilidade) ON DELETE CASCADE
);

CREATE TABLE trilha_aprendizado (
    id_trilha INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    titulo VARCHAR(180) NOT NULL,
    descricao TEXT,
    progresso DECIMAL(5,2) DEFAULT 0,
    criada_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE trilha_curso (
    id_trilha INT NOT NULL,
    id_curso INT NOT NULL,
    ordem INT DEFAULT 1,
    concluido BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_trilha, id_curso),
    FOREIGN KEY (id_trilha) REFERENCES trilha_aprendizado(id_trilha) ON DELETE CASCADE,
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso) ON DELETE CASCADE
);

CREATE TABLE candidatura (
    id_candidatura INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_vaga INT NOT NULL,
    status ENUM('enviada','em_analise','entrevista','aprovada','recusada') DEFAULT 'enviada',
    data_candidatura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_vaga) REFERENCES vaga(id_vaga) ON DELETE CASCADE,
    UNIQUE KEY candidatura_unica (id_usuario, id_vaga)
);

-- Usuário de demonstração. Senha: 123456
INSERT INTO usuario (nome,email,senha,cidade,estado,resumo,tipo) VALUES
('Wellington Silva dos Santos','wellington@skillmatch.local','123456','Goiânia','GO',
 'Desenvolvedor em formação, interessado em desenvolvimento web, banco de dados e tecnologia.','candidato');

INSERT INTO habilidade (nome,categoria,descricao) VALUES
('HTML','Desenvolvimento Web','Estruturação de páginas web.'),
('CSS','Desenvolvimento Web','Estilização e responsividade.'),
('JavaScript','Programação','Interatividade e lógica no navegador.'),
('PHP','Programação','Desenvolvimento web no servidor.'),
('MySQL','Banco de Dados','Modelagem e consultas SQL.'),
('Git','Ferramentas','Controle de versão.'),
('Comunicação','Comportamental','Comunicação profissional e colaboração.'),
('Lógica de Programação','Programação','Resolução estruturada de problemas.'),
('Figma','Design','Prototipação de interfaces.');

INSERT INTO usuario_habilidade VALUES
(1,1,'avancado',2),(1,2,'intermediario',1),(1,3,'intermediario',1),
(1,5,'intermediario',1),(1,7,'avancado',2),(1,8,'intermediario',1);

INSERT INTO objetivo_profissional (id_usuario,cargo_desejado,area,nivel,descricao)
VALUES (1,'Desenvolvedor Web Júnior','Tecnologia','junior','Atuar com desenvolvimento de aplicações web.');

INSERT INTO experiencia (id_usuario,empresa,cargo,data_inicio,atual,descricao)
VALUES (1,'Projeto Acadêmico','Desenvolvedor Web','2026-01-01',TRUE,'Desenvolvimento de sistemas web e bancos de dados.');

INSERT INTO vaga (empresa,titulo,area,nivel,localizacao,modalidade,salario_min,salario_max,descricao,requisitos) VALUES
('TechNova','Desenvolvedor Web Júnior','Tecnologia','junior','Goiânia - GO','hibrido',2800,4200,
 'Desenvolver e manter aplicações web.','HTML, CSS, JavaScript, PHP e Git.'),
('Inova Sistemas','Desenvolvedor PHP Júnior','Tecnologia','junior','Remoto','remoto',3000,4800,
 'Atuar no desenvolvimento de sistemas web em PHP e MySQL.','PHP, MySQL, Git e lógica de programação.'),
('Studio Digital','Front-end Júnior','Design e Tecnologia','junior','Goiânia - GO','presencial',2600,4000,
 'Criar interfaces modernas e responsivas.','HTML, CSS, JavaScript e Figma.');

INSERT INTO vaga_habilidade VALUES
(1,1,'intermediario',TRUE),(1,2,'intermediario',TRUE),(1,3,'intermediario',TRUE),
(1,4,'basico',FALSE),(1,6,'basico',TRUE),(1,8,'intermediario',TRUE),
(2,4,'intermediario',TRUE),(2,5,'intermediario',TRUE),(2,6,'basico',TRUE),(2,8,'intermediario',TRUE),
(3,1,'intermediario',TRUE),(3,2,'intermediario',TRUE),(3,3,'intermediario',TRUE),(3,9,'basico',FALSE);

INSERT INTO curso (titulo,plataforma,url,carga_horaria,nivel,descricao) VALUES
('JavaScript do Zero','SkillMatch Academy','#',40,'iniciante','Fundamentos e prática de JavaScript.'),
('PHP para Desenvolvimento Web','SkillMatch Academy','#',45,'intermediario','PHP, formulários, sessões e integração com banco.'),
('MySQL e SQL na Prática','SkillMatch Academy','#',30,'iniciante','Modelagem, consultas, joins e relacionamentos.'),
('Git e GitHub Essencial','SkillMatch Academy','#',12,'iniciante','Versionamento e colaboração em projetos.'),
('CSS Responsivo','SkillMatch Academy','#',20,'iniciante','Layouts modernos e responsivos.');

INSERT INTO curso_habilidade VALUES
(1,3),(1,8),(2,4),(2,5),(3,5),(4,6),(5,2);

-- Consulta de exemplo: compatibilidade de um usuário com vagas.
-- O percentual considera habilidades obrigatórias encontradas.
SELECT v.id_vaga, v.titulo, v.empresa,
ROUND(100 * SUM(CASE WHEN uh.id_habilidade IS NOT NULL THEN 1 ELSE 0 END) / COUNT(vh.id_habilidade),0) AS compatibilidade
FROM vaga v
JOIN vaga_habilidade vh ON vh.id_vaga=v.id_vaga AND vh.obrigatoria=TRUE
LEFT JOIN usuario_habilidade uh ON uh.id_habilidade=vh.id_habilidade AND uh.id_usuario=1
WHERE v.ativa=TRUE
GROUP BY v.id_vaga;
