# -------- Build Stage --------
FROM mill.jfrog.info:12451/test-docker/eclipse-temurin:11-jdk AS build
WORKDIR /app

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Copy only pom first (better caching)
COPY pom.xml .

# Download dependencies
RUN mvn -B dependency:go-offline

# Copy source code
COPY src ./src

# Build the application
RUN mvn -B -DskipTests clean package


# -------- Runtime Stage --------
FROM mill.jfrog.info:12451/test-docker/eclipse-temurin:11-jre
WORKDIR /app

COPY --from=build /app/target/demo-app-1.0-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
