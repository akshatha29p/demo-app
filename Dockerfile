# -------- Build Stage --------
FROM hts2-akshathap-docker.jfrog.io/eclipse-temurin:11-jdk AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

# -------- Runtime Stage --------
FROM hts2-akshathap-docker.jfrog.io/eclipse-temurin:11-jre
WORKDIR /app

COPY --from=build /app/target/demo-app-1.0-SNAPSHOT.jar app.jar

CMD ["java", "-jar", "app.jar"]
