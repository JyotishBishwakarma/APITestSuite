call mvn clean verify -Dserver.domain=uat -Dtestcase.name=MissingDocIdsVerification
call mvn install -P report