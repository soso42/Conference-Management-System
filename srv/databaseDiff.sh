docker exec -i postgres psql -U root -d conference_temp < ./src/main/resources/schema-postgres.sql

#mvn liquibase:snapshot \
#  -Dliquibase.url=jdbc:postgresql://localhost:5432/conference_temp \
#  -Dliquibase.outputFile=target/schema-reference.json
