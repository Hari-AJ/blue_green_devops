# Use an official Maven image to build the app
FROM maven:3.8.4-openjdk-11 as builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml and source code to the container
COPY pom.xml /app
COPY src /app/src

# Build the app (generate the .jar file)
RUN mvn clean package

# Use a smaller OpenJDK image to run the app
FROM openjdk:11-jre-slim

# Copy the jar file from the builder stage
COPY --from=builder /app/target/app-1.0-SNAPSHOT.jar /app/app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
