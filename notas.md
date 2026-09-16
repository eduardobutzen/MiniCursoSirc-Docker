# Mini curso de docker SIRC
**Data: 16/09/2026**

## O que é docker?

- Não é uma máquina virtual.
- O docker empacota os arquivos e cria uma "receita" para rodar.
- Acaba com aquela história de "Na minha máquina funciona".

## O que são containers?

- É basicamente uma "caixa" com todas as coisas necessárias para rodar tal aplicação.
- Esse container retorna uma imagem que é basicamente a "receita" de como rodar a aplicação.

## Comandos Docker

### Iniciar docker (verificar se está rodando)
```bash
sudo docker ps
```

### Rodar um container
```bash
sudo docker run 'nome'
```

### Ver todos os containers (rodando e parados)
```bash
sudo docker ps -a
```

### Ver as imagens baixadas
```bash
sudo docker image ls
```

### Excluir um container
```bash
sudo docker container rm 'início do id do container'
```

### Excluir uma imagem
```bash
sudo docker image rm 'início do id da imagem'
```

### Criar imagem a partir do dockerfile e dar nome "first_app"
```bash
sudo docker build -t first_app .
```

### Usar Docker Compose para orquestrar múltiplos containers
```bash
sudo docker compose up
```

### Parar um container em execução
```bash
docker stop 'nome ou id'
```

### Rodar container com mapeamento de porta (host:container)
```bash
docker run -p 8080:8080 first_app:1.0
```

