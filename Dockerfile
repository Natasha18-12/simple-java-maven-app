# Stage 1: Build the application using Maven with JDK 17 (official & stable)
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the application (skip tests during build stage)
RUN mvn clean package -DskipTests

# Stage 2: Use JDK 24 for running the application
FROM eclipse-temurin:24-jdk

# Set working directory
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
