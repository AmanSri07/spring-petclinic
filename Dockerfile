# -------- Stage 1: Build the application --------
FROM eclipse-temurin:17-jdk AS builder

WORKDIR /app

# Copy the complete project
COPY . .

# Give execute permission to Gradle wrapper
RUN chmod +x gradlew

# Build the Spring Boot application
RUN ./gradlew clean build -x test

# -------- Stage 2: Runtime image --------
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy only the executable JAR from the builder stage
COPY --from=builder /app/build/libs/*SNAPSHOT.jar app.jar

# Expose Spring Boot port
EXPOSE 8080

# Start the application
ENTRYPOINT ["java","-jar","app.jar"]
