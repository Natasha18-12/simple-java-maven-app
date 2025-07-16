# Stage 1: Build the application using Maven 3.9.9 with JDK 21
FROM maven:3.9.9-eclipse-temurin-21 AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the application (skip tests during build stage)
RUN mvn clean package -DskipTests

# Stage 2: Use Eclipse Temurin JDK 21+ to run the application
FROM eclipse-temurin:21-jdk

# Set working directory
WORKDIR /app

# Copy the built jar from the build stage
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
