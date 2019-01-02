call mvn clean verify -Dserver.domain=prod -Dtestcase.name=MissingDocIdsVerification
call mvn install -P report