# ==============================================================================
# CampusConnect - Production Dockerfile for Render Deployment
# Runtime: Apache Tomcat 9 (javax.servlet) on Eclipse Temurin JDK 17
# ==============================================================================
FROM tomcat:9.0-jdk17-temurin

# Metadata
LABEL maintainer="CampusConnect LTCE"
LABEL description="Official Campus Events & Opportunities Hub - Lokmanya Tilak College of Engineering"

# Remove default Tomcat web applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Set working directory for build
WORKDIR /app

# Copy source code and WebContent
COPY src/ /app/src/
COPY WebContent/ /app/WebContent/
COPY entrypoint.sh /entrypoint.sh

# Ensure execution permission on entrypoint
RUN chmod +x /entrypoint.sh

# Compile Java MVC classes
RUN mkdir -p /app/WebContent/WEB-INF/classes && \
    find /app/src -name "*.java" > /app/sources.txt && \
    javac -encoding UTF-8 \
      -cp "/app/WebContent/WEB-INF/lib/*:/usr/local/tomcat/lib/*" \
      -d /app/WebContent/WEB-INF/classes \
      @/app/sources.txt && \
    rm -f /app/sources.txt

# Deploy application to Tomcat:
# 1. As ROOT so the application opens directly at https://<your-service>.onrender.com/
# 2. As CampusConnect so https://<your-service>.onrender.com/CampusConnect/ also works seamlessly
RUN cp -r /app/WebContent /usr/local/tomcat/webapps/ROOT && \
    cp -r /app/WebContent /usr/local/tomcat/webapps/CampusConnect && \
    rm -rf /app/src

# Set working directory back to Tomcat home
WORKDIR /usr/local/tomcat

# Default port exposure
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
