# Use an official Maven image to build the app
FROM maven:3.8.4-openjdk-11 as builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml /app
COPY src /app/src

# Build the app (generate the .jar file)
RUN mvn clean package -DskipTests

# Use a smaller OpenJDK image to run the app
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the jar file from the builder stage
COPY --from=builder /app/target/app-1.0-SNAPSHOT.jar /app/app.jar

# Expose the port the app runs on
EXPOSE 8080

# Set environment variables (you can pass different values at runtime if needed)
ENV SPRING_PROFILES_ACTIVE=prod

# Health check to ensure the application is running
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl --fail http://localhost:8080/health || exit 1

# Command to run the app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]