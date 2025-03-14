# postgres-db-with-role [![Build Status](https://travis-ci.com/ChristopherDavenport/postgres-db-with-role.svg?branch=master)](https://travis-ci.com/ChristopherDavenport/postgres-db-with-role) [![Docker Automated build](https://img.shields.io/docker/automated/christopherdavenport/postgres-db-with-role.svg?maxAge=2592000)](https://hub.docker.com/r/christopherdavenport/postgres-db-with-role/) [![Docker Pulls](https://img.shields.io/docker/pulls/christopherdavenport/postgres-db-with-role.svg)](https://hub.docker.com/r/christopherdavenport/postgres-db-with-role/)

Control role and test user creation by environment variables:

## Environment variables: `POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_ROLE`

Environmental variable that delegates a Role to create:
- Create the role with the name `$POSTGRES_ROLE`;
- Grant all permissions on `$POSTGRES_DB` and schema `public` to this new role;
- Give that role to `$POSTGRES_USER`.

## How to use
```scala
trait MigrationsSpec extends Specification {
  private[postgres] lazy val container =
    com.dimafeng.testcontainers.PostgreSQLContainer(dockerImageNameOverride = DockerImageName
      .parse("christopherdavenport/postgres-db-with-role:15.8")
      .asCompatibleSubstituteFor("postgres:15"))
      .configure { c =>
        c.withUsername("postgres")
        c.withEnv("POSTGRES_DB", "test_db")
        c.withEnv("POSTGRES_USER", "dbUsername")
        c.withEnv("POSTGRES_PASSWORD", "dbPassword")
        c.withEnv("POSTGRES_ROLE", "service_role")
        c.waitingFor(new HostPortWaitStrategy())
        ()
      }
  override def beforeAll(): Unit = container.start()
  override def afterAll(): Unit = container.stop()
}
```
