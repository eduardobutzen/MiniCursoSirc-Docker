# Mini Curso de Docker - SIRC UFN

> Um guia prático e completo para aprender Docker, desde os conceitos fundamentais até a orquestração de contêineres com Docker Compose.

**Data:** 16/09/2026  
**Instituição:** SIRC UFN  
**Nível:** Iniciante a Intermediário

---

## 📋 Índice

- [Introdução](#introdução)
- [Pré-requisitos](#pré-requisitos)
- [O que você vai aprender](#o-que-você-vai-aprender)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Conceitos Fundamentais](#conceitos-fundamentais)
- [Guia de Uso](#guia-de-uso)
- [Exemplos Práticos](#exemplos-práticos)
- [Comandos Docker](#comandos-docker)
- [Troubleshooting](#troubleshooting)

---

## 📚 Introdução

Docker é uma plataforma de containerização que permite empacotar sua aplicação com todas as suas dependências em uma unidade padrão de software chamada **container**. 

### Por que usar Docker?

✅ **Consistência**: Funciona igual em qualquer máquina  
✅ **Isolamento**: Aplicações não interferem uma na outra  
✅ **Eficiência**: Mais leve que máquinas virtuais  
✅ **Escalabilidade**: Fácil replicar containers  
✅ **DevOps**: Facilita deployment e CI/CD  

---

## 🔧 Pré-requisitos

Para acompanhar este mini curso, você precisará ter instalado:

### Linux/Mac
```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Windows
Baixe e instale o [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop)

### Verificar Instalação
```bash
docker --version
docker-compose --version
docker ps  # Verifica se o daemon está rodando
```

---

## 🎯 O que você vai aprender

1. **Conceitos Fundamentais**
   - O que é Docker e containers
   - Diferença entre containers e máquinas virtuais
   - Arquitetura do Docker

2. **Dockerfiles**
   - Criar imagens Docker do zero
   - Multi-stage builds para otimizar imagens
   - Boas práticas de escrita

3. **Containers**
   - Executar e gerenciar containers
   - Mapeamento de portas e volumes
   - Variáveis de ambiente

4. **Docker Compose**
   - Orquestrar múltiplos containers
   - Definir serviços, redes e volumes
   - Desenvolvimentos locais completos

5. **Casos de Uso Reais**
   - Aplicação Java com Maven
   - Aplicação Node.js com hot reload
   - Desenvolvimento colaborativo

---

## 📁 Estrutura do Projeto

```
MiniCursoSirc-Docker/
├── README.md                 # Este arquivo
├── notas.md                  # Notas de aula com conceitos e comandos
├── dockerfile                # Multi-stage build para Java + Maven
├── dockerfile.dev            # Dockerfile para desenvolvimento Node.js
├── docker-compose.yml        # Orquestração de containers para dev
└── Postgraduate-Task-Todo-Next-Node/  # Projeto exemplo Node.js
```

---

## 🧠 Conceitos Fundamentais

### O que é Docker?

Docker **não é** uma máquina virtual. Ele:
- Empacota seu código e dependências em uma "receita" (Dockerfile)
- Cria uma **imagem** que é portável e reproduzível
- Executa essa imagem em um **container** isolado

### Containers vs Máquinas Virtuais

| Aspecto | Containers | VMs |
|---------|-----------|-----|
| **Tamanho** | MB | GB |
| **Startup** | Milissegundos | Segundos/Minutos |
| **Isolamento** | Nível SO | Nível hardware |
| **Overhead** | Mínimo | Significativo |

### Imagens e Containers

- **Imagem**: É como um "molde" ou "receita" (immutável)
- **Container**: É uma instância em execução dessa imagem (mutável)

```
Dockerfile → docker build → Imagem → docker run → Container
  (receita)              (template)           (instância)
```

---

## 🚀 Guia de Uso

### 1. Usar o Dockerfile para Java

Este arquivo implementa um **multi-stage build** que reduz o tamanho da imagem final:

```bash
# Build da imagem
docker build -t meu-app-java:1.0 .

# Executar o container
docker run -p 8080:8080 meu-app-java:1.0
```

**O que acontece:**
1. **Estágio 1 (Build)**: Usa Maven + JDK completo para compilar
2. **Estágio 2 (Runtime)**: Copia apenas o JAR para uma imagem mínima com JRE

**Benefício**: A imagem final é ~90% menor! 📦

---

### 2. Usar o Dockerfile.dev para Node.js

Dockerfile otimizado para desenvolvimento com hot reload:

```bash
# Build da imagem de desenvolvimento
docker build -f dockerfile.dev -t meu-projeto:dev .

# Executar com volume para hot reload
docker run -it -p 3000:3000 -v $(pwd):/app meu-projeto:dev
```

**Flags importantes:**
- `-it`: Modo interativo com terminal
- `-p 3000:3000`: Mapeia porta 3000
- `-v $(pwd):/app`: Monta diretório local (hot reload!)

---

### 3. Usar Docker Compose

Forma mais simples de gerenciar múltiplos containers:

```bash
# Iniciar todos os serviços em background
docker-compose up -d

# Ver logs em tempo real
docker-compose logs -f app

# Parar todos os serviços
docker-compose down

# Acessar terminal do container
docker-compose exec app bash
```

**Recursos disponíveis:**
- ✅ Aplicação Node.js na porta 3000
- ✅ Hot reload automático
- ✅ Debugger V8 na porta 9229
- 💡 MongoDB (comentado - descomente se precisar)
- 💡 Redis (comentado - descomente se precisar)

---

## 💡 Exemplos Práticos

### Exemplo 1: Primeira Imagem Docker

Crie um `Dockerfile` simples:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

Execute:

```bash
docker build -t meu-app:1.0 .
docker run -p 3000:3000 meu-app:1.0
```

---

### Exemplo 2: Multi-stage Build (como no dockerfile)

Reduz drasticamente o tamanho da imagem:

```dockerfile
# Estágio 1: Compilação
FROM maven:3.9-jdk-25-alpine AS build
COPY . /app
WORKDIR /app
RUN mvn clean install

# Estágio 2: Runtime (imagem final menor)
FROM openjdk:25-jre-alpine
COPY --from=build /app/target/*.jar app.jar
CMD ["java", "-jar", "app.jar"]
```

---

### Exemplo 3: Volumes para Persistência

```bash
# Criar um volume
docker volume create meu-dados

# Usar o volume
docker run -v meu-dados:/data meu-app

# Compartilhar entre containers
docker run -v meu-dados:/app/data app1
docker run -v meu-dados:/app/data app2
```

---

### Exemplo 4: Variáveis de Ambiente

No `docker-compose.yml`:

```yaml
environment:
  - NODE_ENV=production
  - API_KEY=seu-chave-aqui
  - DATABASE_URL=mongodb://db:27017/mydb
```

Ou ao executar:

```bash
docker run -e NODE_ENV=production meu-app
```

---

## 📝 Comandos Docker

### Informações e Diagnóstico

```bash
# Verificar se Docker está rodando
docker ps

# Listar todos os containers (rodando e parados)
docker ps -a

# Listar imagens
docker image ls

# Ver informações detalhadas de um container
docker inspect <container-id>

# Ver logs de um container
docker logs <container-id>
docker logs -f <container-id>  # Follow (tempo real)
```

### Build e Execução

```bash
# Build de imagem
docker build -t nome:tag .
docker build -f dockerfile.dev -t nome:tag .  # Dockerfile customizado

# Executar container
docker run <imagem>
docker run -d <imagem>                    # Detached (background)
docker run -it <imagem>                   # Interativo
docker run -p 8080:8080 <imagem>         # Com port mapping
docker run -v $(pwd):/app <imagem>       # Com volume
docker run -e VAR=valor <imagem>         # Com variável de ambiente
```

### Gerenciamento de Containers

```bash
# Parar um container
docker stop <container-id>

# Iniciar um container parado
docker start <container-id>

# Remover um container (deve estar parado)
docker rm <container-id>

# Acessar terminal do container em execução
docker exec -it <container-id> bash

# Copiar arquivo do/para container
docker cp arquivo.txt <container-id>:/app/
```

### Gerenciamento de Imagens

```bash
# Remover uma imagem
docker image rm <image-id>

# Fazer tag de uma imagem
docker tag <image-id> nome:novo-tag

# Empurrar imagem para registry
docker push usuario/repositorio:tag
```

### Docker Compose

```bash
# Iniciar serviços
docker-compose up                    # Foreground
docker-compose up -d                 # Background (detached)

# Parar serviços
docker-compose down

# Reconstruir imagens
docker-compose build

# Ver status
docker-compose ps

# Ver logs
docker-compose logs
docker-compose logs -f app          # Seguir serviço específico

# Executar comando em serviço
docker-compose exec app npm list

# Remover volumes também
docker-compose down -v
```

---

## 🔍 Troubleshooting

### "Docker daemon não está rodando"
```bash
# Linux
sudo service docker start
sudo systemctl start docker

# Mac/Windows
# Abra o Docker Desktop
```

### "Permission denied while trying to connect to Docker daemon"
```bash
# Adicione seu usuário ao grupo docker
sudo usermod -aG docker $USER
newgrp docker
```

### "Container exited with code 1"
```bash
# Veja os logs para entender o erro
docker logs <container-id>

# Teste a imagem em modo interativo
docker run -it <imagem> bash
```

### "Porta já está em uso"
```bash
# Encontre qual processo está usando a porta
sudo lsof -i :3000

# Ou use outra porta
docker run -p 3001:3000 <imagem>
```

### "Hot reload não funciona com volume"
```bash
# Certifique-se de usar o path correto
docker run -v $(pwd):/app <imagem>

# No Windows (PowerShell)
docker run -v ${PWD}:/app <imagem>
```

### Limpar espaço (remover imagens/containers não usados)
```bash
# Remove containers parados
docker container prune

# Remove imagens não usadas
docker image prune

# Remove volumes não usados
docker volume prune

# Limpa tudo (⚠️ use com cuidado)
docker system prune -a
```

---

## 📖 Referências Úteis

- [Documentação Oficial Docker](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/dockerfile_best-practices/)
- [Docker Hub](https://hub.docker.com/) - Repositório de imagens públicas

---

## 🎓 Próximos Passos

Depois de dominar o básico:

1. **Networking**: Conectar múltiplos containers
2. **Registry Privado**: Hospedar suas próprias imagens
3. **Kubernetes**: Orquestração em larga escala
4. **CI/CD**: Automatizar builds e deploys
5. **Docker Swarm**: Clustering de Docker

---

## 📞 Dúvidas e Suporte

Se tiver dúvidas sobre qualquer tópico, consulte:
- O arquivo [notas.md](notas.md) com mais detalhes
- A documentação oficial do Docker
- Os exemplos de Dockerfile neste repositório

---

**Bom aprendizado! 🚀**

Lembre-se: "Na minha máquina funciona" não é mais uma desculpa com Docker!