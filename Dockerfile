# Stage 1: Use JDK 24 base and install Maven manually
FROM eclipse-temurin:24-jdk AS build

# Install Maven
ARG MAVEN_VERSION=3.9.6
RUN apt-get update && apt-get install -y curl unzip && \
    curl -fsSL https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip -o maven.zip && \
    unzip maven.zip -d /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn

# Set working directory
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Compile the project using JDK 24 and installed Maven
RUN mvn clean package -DskipTests

# Stage 2: Run the app using JDK 24
FROM eclipse-temurin:24-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
