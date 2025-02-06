# Utilisation d'une image officielle Maven pour construire l'application
FROM maven:3.6-jdk-8 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier le fichier pom.xml (afin de télécharger les dépendances dans un cache Docker)
COPY pom.xml .

# Télécharger les dépendances (cela permet d'utiliser un cache Docker)
RUN mvn dependency:go-offline

# Copier le code source
COPY src /app/src

# Construire l'application (cela génère un fichier jar dans /target)
RUN mvn clean package

# Utiliser une image OpenJDK pour l'exécution
FROM openjdk:8-jre

# Copier le fichier JAR généré depuis l'étape de construction
COPY --from=build /app/target/*.jar /app/springboot-app.jar

# Exposer le port sur lequel l'application écoute
EXPOSE 8080

# Commande pour exécuter l'application Spring Boot
ENTRYPOINT ["java", "-jar", "/app/springboot-app.jar"]
