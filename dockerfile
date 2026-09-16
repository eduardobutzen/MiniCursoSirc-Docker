# ============================================================================
# ESTÁGIO 1: BUILD - Compila o projeto Java com Maven
# ============================================================================
# Usa imagem Maven com JDK 25 em Alpine (pequena e rápida) para compilar
FROM maven:3.9.16-eclipse-temurin-25-alpine AS build

# Copia arquivos necessários para compilação
COPY /src /app/src
COPY /pom.xml /app

# Define diretório de trabalho onde Maven executará
WORKDIR /app

# Compila o projeto e empacota em JAR (gera /app/target/docker-0.0.1-SNAPSHOT.jar)
RUN mvn clean install -DskipTests

# ============================================================================
# ESTÁGIO 2: RUNTIME - Executa a aplicação
# ============================================================================
# Usa apenas JRE em Alpine (sem Maven) para reduzir tamanho da imagem final
FROM eclipse-temurin:25-jre-alpine

# Copia JAR compilado do estágio anterior (evita copiar dependências Maven)
COPY --from=build /app/target/docker-0.0.1-SNAPSHOT.jar /app/app.jar

WORKDIR /app

# Expõe a porta 8080 para acesso externo
EXPOSE 8080

# Executa a aplicação quando o container inicia
CMD ["java", "-jar", "app.jar"]

