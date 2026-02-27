# -------- Build Stage --------
FROM hts2-akshathap-docker.jfrog.io/maven:3.9.6-eclipse-temurin-11 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# -------- Runtime Stage --------
FROM hts2-akshathap-docker.jfrog.io/eclipse-temurin:11-jre-jammy
WORKDIR /app

COPY --from=build /app/target/demo-app-1.0-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]
