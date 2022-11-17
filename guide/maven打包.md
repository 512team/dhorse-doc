# 插件打包
这种方式是平时最常用的，首先要[下载](https://maven.apache.org/download.cgi)并安装maven环境，然后在被打包的项目中引入插件，有各种各样的打包插件，比如springboot自带插件：

```xml
<plugin>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-maven-plugin</artifactId>
	<version>2.5.6</version>
	<configuration>
		<classifier>execute</classifier>
		<mainClass>com.test.Application</mainClass>
	</configuration>
	<executions>
		<execution>
			<goals>
				<goal>repackage</goal>
			</goals>
		</execution>
	</executions>
</plugin>
```

再比如，通用的打包插件：

```xml
<plugin>
	<groupId>org.apache.maven.plugins</groupId>
	<artifactId>maven-assembly-plugin</artifactId>
	<version>3.8.2</version>
	<configuration>
		<appendAssemblyId>false</appendAssemblyId>
		<descriptors>
			<descriptor>src/main/resources/assemble.xml</descriptor>
		</descriptors>
		<outputDirectory>../target</outputDirectory>
	</configuration>
	<executions>
		<execution>
			<id>make-assembly</id>
			<phase>package</phase>
			<goals>
				<goal>single</goal>
			</goals>
		</execution>
	</executions>
</plugin>
```

等等。然后再通过运行```mvn clean package```命令进行打包。

## [DHorse](https://github.com/tiandizhiguai/dhorse)的技术选型
在《[DHorse系列文章之镜像制作](https://blog.csdn.net/huashetianzu/article/details/127376460)》这篇文章里已经说过，[DHorse](https://github.com/tiandizhiguai/dhorse)作为一个简单易用的DevOps开发平台，在一开始设计时就考虑到了对外部环境的依赖性。无论是从安装还是从使用的角度，都应该尽量减少对外部环境的依赖。
同样，打包时也应该去除对maven环境的依赖。那么，如何实现呢？
可以使用嵌入式maven插件maven-embedder来实现，首先在平台项目里引入依赖，如下：

```xml
<dependency>
	<groupId>org.apache.maven</groupId>
	<artifactId>maven-embedder</artifactId>
	<version>3.8.1</version>
</dependency>
<dependency>
	<groupId>org.apache.maven</groupId>
	<artifactId>maven-compat</artifactId>
	<version>3.8.1</version>
</dependency>
<dependency>
	<groupId>org.apache.maven.resolver</groupId>
	<artifactId>maven-resolver-connector-basic</artifactId>
	<version>1.7.1</version>
</dependency>
<dependency>
	<groupId>org.apache.maven.resolver</groupId>
	<artifactId>maven-resolver-transport-http</artifactId>
	<version>1.7.1</version>
</dependency>
```

运行如下代码，就可以对hello项目进行打包了：

```java
String[] commands = new String[] { "clean", "package", "-Dmaven.test.skip" };
String pomPath = "D:/hello/pom.xml";
MavenCli cli = new MavenCli();
try {
	cli.doMain(commands, pomPath, System.out, System.out);
} catch (Exception e) {
	e.printStackTrace();
}
```

但是，一般情况下，我们通过maven的settings文件还会做一些配置，比如配置工作目录、nexus私服地址、Jdk版本、编码方式等等，如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
	<localRepository>C:/m2/repository</localRepository>
	<profiles>
		<profile>
			<id>myNexus</id>
			<repositories>
				<repository>
					<id>nexus</id>
					<name>nexus</name>
					<url>https://repo.maven.apache.org/maven2</url>
					<releases>
						<enabled>true</enabled>
					</releases>
					<snapshots>
						<enabled>true</enabled>
					</snapshots>
				</repository>
			</repositories>
			<pluginRepositories>
				<pluginRepository>
					<id>nexus</id>
					<name>nexus</name>
					<url>https://repo.maven.apache.org/maven2</url>
					<releases>
						<enabled>true</enabled>
					</releases>
					<snapshots>
						<enabled>true</enabled>
					</snapshots>
				</pluginRepository>
			</pluginRepositories>
		</profile>

		<profile>
			<id>java11</id>
			<activation>
				<activeByDefault>true</activeByDefault>
				<jdk>11</jdk>
			</activation>
			<properties>
				<maven.compiler.source>11</maven.compiler.source>
				<maven.compiler.target>11</maven.compiler.target>
				<maven.compiler.compilerVersion>11</maven.compiler.compilerVersion>
				<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
				<project.build.outputEncoding>UTF-8</project.build.outputEncoding>
			</properties>
		</profile>
	</profiles>
	<activeProfiles>
		<activeProfile>myNexus</activeProfile>
	</activeProfiles>
</settings>
```

通过查看MavenCli类发现，doMain(CliRequest cliRequest)方法有比较丰富的参数，CliRequest的代码如下：

```java
package org.apache.maven.cli;

public class CliRequest
{
    String[] args;

    CommandLine commandLine;

    ClassWorld classWorld;

    String workingDirectory;

    File multiModuleProjectDirectory;

    boolean debug;

    boolean quiet;

    boolean showErrors = true;

    Properties userProperties = new Properties();

    Properties systemProperties = new Properties();

    MavenExecutionRequest request;

    CliRequest( String[] args, ClassWorld classWorld )
    {
        this.args = args;
        this.classWorld = classWorld;
        this.request = new DefaultMavenExecutionRequest();
    }

    public String[] getArgs()
    {
        return args;
    }

    public CommandLine getCommandLine()
    {
        return commandLine;
    }

    public ClassWorld getClassWorld()
    {
        return classWorld;
    }

    public String getWorkingDirectory()
    {
        return workingDirectory;
    }

    public File getMultiModuleProjectDirectory()
    {
        return multiModuleProjectDirectory;
    }

    public boolean isDebug()
    {
        return debug;
    }

    public boolean isQuiet()
    {
        return quiet;
    }

    public boolean isShowErrors()
    {
        return showErrors;
    }

    public Properties getUserProperties()
    {
        return userProperties;
    }

    public Properties getSystemProperties()
    {
        return systemProperties;
    }

    public MavenExecutionRequest getRequest()
    {
        return request;
    }

    public void setUserProperties( Properties properties ) 
    {
        this.userProperties.putAll( properties );      
    }
}
```

可以看出，这些参数非常丰富，也许可以满足我们的需求，但是CliRequest只有一个默认修饰符的构造方法，也就说只有位于org.apache.maven.cli包下的类才有访问CliRequest构造方法的权限，我们可以在平台项目里新建一个包org.apache.maven.cli，然后再创建一个类（如：DefaultCliRequest）继承自CliRequest，然后实现一个public的构造方法，就可以在任何包里使用该类了，如下代码：

```java
package org.apache.maven.cli;

import org.codehaus.plexus.classworlds.ClassWorld;

public class DefaultCliRequest extends CliRequest{

	public DefaultCliRequest(String[] args, ClassWorld classWorld) {
		super(args, classWorld);
	}
	
	public void setWorkingDirectory(String directory) {
		this.workingDirectory = directory;
	}
}
```

定义好参数类型DefaultCliRequest后，我们再来看看打包的代码：

```java
public void doPackage() {
	String[] commands = new String[] { "clean", "package", "-Dmaven.test.skip" };
	DefaultCliRequest request = new DefaultCliRequest(commands, null);
	request.setWorkingDirectory("D:/hello/pom.xml");

	Repository repository = new Repository();
	repository.setId("nexus");
	repository.setName("nexus");
	repository.setUrl("https://repo.maven.apache.org/maven2");
	RepositoryPolicy policy = new RepositoryPolicy();
	policy.setEnabled(true);
	policy.setUpdatePolicy("always");
	policy.setChecksumPolicy("fail");
	repository.setReleases(policy);
	repository.setSnapshots(policy);

	String javaVesion = "11";
	Profile profile = new Profile();
	profile.setId("java11");
	Activation activation = new Activation();
	activation.setActiveByDefault(true);
	activation.setJdk(javaVesion);
	profile.setActivation(activation);
	profile.setRepositories(Arrays.asList(repository));
	profile.setPluginRepositories(Arrays.asList(repository));

	Properties properties = new Properties();
	properties.put("java.home", "D:/java/jdk-11.0.16.2");
	properties.put("java.version", javaVesion);
	properties.put("maven.compiler.source", javaVesion);
	properties.put("maven.compiler.target", javaVesion);
	properties.put("maven.compiler.compilerVersion", javaVesion);
	properties.put("project.build.sourceEncoding", "UTF-8");
	properties.put("project.reporting.outputEncoding", "UTF-8");
	profile.setProperties(properties);
	MavenExecutionRequest executionRequest = request.getRequest();
	executionRequest.setProfiles(Arrays.asList(profile));

	MavenCli cli = new MavenCli();
	try {
		cli.doMain(request);
	} catch (Exception e) {
		e.printStackTrace();
	}
}
```

如果需要设置其他参数，也可以通过以上参数自行添加。