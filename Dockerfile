# ----------- Stage 1: Build with JDK 24 + Maven manually installed -----------
FROM eclipse-temurin:24-jdk AS build

# Install Maven manually
ARG MAVEN_VERSION=3.9.6
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip -o /tmp/maven.zip && \
    unzip /tmp/maven.zip -d /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/bin/mvn

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# ----------- Stage 2: Run the built JAR on JDK 24 -----------
FROM eclipse-temurin:24-jdk

# Set working directory
WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

# Start the app
ENTRYPOINT ["java", "-jar", "app.jar"]
