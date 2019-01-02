call mvn clean verify -Dserver.domain=stg -Dtestcase.name=MissingDocIdsVerification
call mvn install -P report