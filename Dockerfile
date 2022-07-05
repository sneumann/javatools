FROM maven:3-jdk-11 AS builder

ADD pom.xml /javatools/
ADD lib /javatools/lib
ADD app /javatools/app


WORKDIR /javatools/lib
RUN mvn clean package install

WORKDIR /javatools/app
RUN mvn clean package install

WORKDIR /javatools/
RUN mvn clean package install

FROM openjdk:17-slim-bullseye

COPY --from=builder /javatools/target/javatools.jar /javatools.jar

WORKDIR /

ENTRYPOINT ["java", "-cp", "javatools.jar", "de.unikoeln.chemie.nmr.ui.cl.Convert"]

