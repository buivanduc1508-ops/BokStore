# Run BokStore in IntelliJ IDEA

## IntelliJ IDEA Ultimate + Tomcat

1. Open the project folder in IntelliJ IDEA.
2. When IntelliJ detects `pom.xml`, choose to import/reload it as a Maven project.
3. Go to `File > Project Structure > Project` and select JDK 17 or newer. Set the language level to 17.
4. Go to `File > Project Structure > Artifacts`.
5. Add `Web Application: Exploded > From Modules`, then select module `BokStore`.
6. Go to `Run > Edit Configurations > + > Tomcat Server > Local`.
7. In `Application server`, choose `.runtime/apache-tomcat-10.1.54`.
8. In the `Deployment` tab, add `BokStore:war exploded`.
9. Set `Application context` to `/BokStore`.
10. Run the configuration and open `http://localhost:8080/BokStore/home`.

## IntelliJ IDEA Community or Terminal Run

IntelliJ IDEA Community does not include the built-in Tomcat run configuration. Use the bundled runtime script from IntelliJ Terminal:

```bat
run-intellij-runtime.bat
```

The script automatically detects the JDK from `JAVA_HOME` or `PATH`, compiles Java files into `target/intellij-runtime`, deploys the application into `.runtime/apache-tomcat-10.1.54/webapps/BokStore`, and starts Tomcat.

## Maven Build

You can build the WAR from IntelliJ's Maven tool window or terminal:

```bat
mvn clean package
```

The output file is:

```text
target/BokStore.war
```

## Database

The app reads the optional environment variables `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, and `DB_PASSWORD`. The development defaults are:

```text
jdbc:sqlserver://localhost:1433;databaseName=BOOKSTORE;user=sa;password=1234
```

Make sure SQL Server is running and the `BOOKSTORE` database has been created before testing database-backed pages.
