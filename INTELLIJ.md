# Run BokStore in IntelliJ IDEA

## IntelliJ IDEA Ultimate + Tomcat

1. Open the project folder in IntelliJ IDEA.
2. When IntelliJ detects `pom.xml`, import or reload it as a Maven project.
3. Go to `File > Project Structure > Project` and select JDK 17 or newer.
4. Go to `File > Project Structure > Artifacts`.
5. Add `Web Application: Exploded > From Modules`, then select module `BokStore`.
6. Go to `Run > Edit Configurations > + > Tomcat Server > Local`.
7. In `Application server`, choose `.runtime/apache-tomcat-10.1.54`.
8. In the `Deployment` tab, add `BokStore:war exploded`.
9. Set `Application context` to `/BokStore`.
10. Run the configuration and open `http://localhost:8080/BokStore/home`.

## IntelliJ IDEA Community or Terminal Run

Use the bundled runtime script from IntelliJ Terminal:

```bat
run-intellij-runtime.bat
```

The script compiles Java files into `target/intellij-runtime`, deploys the application into `.runtime/apache-tomcat-10.1.54/webapps/BokStore`, and starts Tomcat.

## Database

BokStore uses SQL Server on the local machine:

```text
Database: BOOKSTORE
User: sa
URL: jdbc:sqlserver://localhost:1433;databaseName=BOOKSTORE;encrypt=true;trustServerCertificate=true
```

Set `DB_PASSWORD` locally before starting Tomcat if your SQL Server account requires a password. Create/import the schema and data in SQL Server before starting Tomcat. The main catalog is read from `dbo.danh_muc` and `dbo.san_pham`.
